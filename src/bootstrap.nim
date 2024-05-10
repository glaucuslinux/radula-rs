# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  cerata, constants, tools

func backupToolchain*() =
  discard rsync(getEnv($CRSD), getEnv($BAKD))

proc buildCross*() =
  buildCerata([
    # Filesystem
    $filesystem,

    # Package Management
    $radCerata.cerata,
    $rad,

    # Compatibility
    $muslFts,
    $muslUtils,
    $linuxHeaders,

    # Init
    $skalibs,
    $nsss,
    $execline,
    $mdevd,
    $s6,
    $utmps,

    # Permissions & Capabilities
    $attr,
    $acl,
    $libcap,
    $libcapNg,
    $shadow,

    # Hashing
    $libressl,
    $xxhash,

    # Userland
    $toybox,
    $diffutils,
    $file,
    $findutils,
    $sed,

    # Development
    $expat,

    # Compression
    $bzip2,
    $lz4,
    $xz,
    $zlibNg,
    $pigz,
    $zstd,
    $libarchive,

    # Development
    $autoconf,
    $automake,
    $binutils,
    $byacc,
    $flex,
    $gcc,
    $gettextTiny,
    $help2man,
    $libtool,
    $m4,
    $radCerata.make,
    $mawk,
    $patch,
    $pkgconf,
    $muon,
    $rsync,
    $samurai,

    # Editors, Pagers and Shells
    $netbsdCurses,
    $libedit,
    $pcre2,
    $bash,

    # Userland
    $grep,

    # Utilities
    $kmod,
    $libudevZero,
    $procpsNg,
    $psmisc,
    $utilLinux,
    $e2fsprogs,

    # Services
    $s6LinuxInit,
    $s6Rc,
    $s6BootScripts,

    # Kernel
    $linux
  ], $cross, false)

proc buildNative*() =
  buildCerata([
    # Filesystem
    $filesystem,

    # Development
    $musl,
    $cmake,
    $gmp,
    $mpfr,
    $mpc,
    $isl,
    $perl,
    $texinfo,

    # Package Management
    $radCerata.cerata,
    $rad,

    # Compatibility
    $muslFts,
    $linuxHeaders,

    # Permissions & Capabilities
    $attr,
    $acl,
    $libcap,
    $libcapNg,
    $opendoas,
    $shadow,

    # Hashing
    $libressl,
    $xxhash,

    # Userland
    $diffutils,
    $file,
    $findutils,
    $grep,
    $sed,
    $toybox,

    # Compression
    $bzip2,
    $lz4,
    $xz,
    $zlibNg,
    $pigz,
    $zstd,
    $libarchive,

    # Development
    $autoconf,
    $automake,
    $binutils,
    $byacc,
    $expat,
    $flex,
    $gcc,
    $gettextTiny,
    $help2man,
    $libtool,
    $m4,
    $radCerata.make,
    $mawk,
    $patch,
    $pkgconf,
    $rsync,
    $samurai,

    # Editors, Pagers and Shells
    $netbsdCurses,
    $libedit,
    $pcre2,
    $bash,
    $yash,
    $less,
    $mandoc,
    $vim,

    # Networking
    $iproute2,
    $iputils,
    $sdhcp,
    $wget2,

    # Utilities
    $kbd,
    $kmod,
    $libudevZero,
    $procpsNg,
    $psmisc,
    $utilLinux,
    $e2fsprogs,

    # Init & Services
    $skalibs,
    $nsss,
    $execline,
    $mdevd,
    $s6,
    $utmps,
    $s6LinuxInit,
    $s6Rc,
    $s6BootScripts,

    # Kernel
    $linux
  ], $native, false)

proc buildToolchain*() =
  buildCerata([
    $muslHeaders,
    $binutils,
    $gcc,
    $musl,
    $libgcc,
    $libstdcxxV3
  ], $toolchain, false)

proc cleanBootstrap*() =
  removeDir(getEnv($CRSD))
  removeDir(getEnv($LOGD))
  removeDir(getEnv($TBLD))
  removeDir(getEnv($TLCD))

proc distcleanBootstrap*() =
  removeDir(getEnv($BAKD))

  cleanBootstrap()

  removeDir(getEnv($SRCD))
  removeDir(getEnv($GLAD) / $tmp)

proc init*() =
  createDir(getEnv($BAKD))
  createDir(getEnv($CRSD))
  createDir(getEnv($LOGD))
  createDir(getEnv($SRCD))
  createDir(getEnv($TBLD))
  createDir(getEnv($TSRC))
  createDir(getEnv($TLCD))

proc prepareCross*() =
  discard rsync(getEnv($BAKD) / $cross, getEnv($GLAD))

  removeDir(getEnv($TBLD))
  createDir(getEnv($TBLD))

proc prepareNative*() =
  removeDir(getEnv($TBLD))
  createDir(getEnv($TBLD))

  # Create the `src` dir if it doesn't exist, but don't remove it if it does exist!
  createDir(getEnv($TSRC))

proc releaseImg*() =
  if not isAdmin():
    abort(&"""{"1":8}{"permission denied":48}""")

  let
    img = getEnv($GLAD) / &"""{glaucus}-{s6}-{x86_64_v3}-{now().format("YYYYMMdd")}{CurDir}img"""

    # Find the first unused loop device
    device = execCmdEx(&"{losetup} -f")[0].strip()

    partition = device & "p1"

    path = DirSep & $mnt / $glaucus

  # Create a new IMG file
  discard execCmd(&"{dd} bs=1M count={imgSize} if=/dev/zero of={img} {shellRedirect}")

  # Partition the IMG file
  discard execCmd(&"{parted} {Parted} {img} mklabel msdos {shellRedirect}")
  discard execCmd(&"{parted} {Parted} -a none {img} mkpart primary ext4 1 {imgSize} {shellRedirect}")
  discard execCmd(&"{parted} {Parted} -a none {img} set 1 boot on {shellRedirect}")

  # Load the `loop` module
  discard execCmd(&"{modprobe} loop {shellRedirect}")

  # Detach all used loop devices
  discard execCmd(&"{losetup} -D {shellRedirect}")

  # Associate the first unused loop device with the IMG file
  discard execCmd(&"{losetup} {device} {img} {shellRedirect}")

  # Notify the kernel about the new partition on the IMG file
  discard execCmd(&"{partx} -a {device} {shellRedirect}")

  # Create an `ext4` filesystem in the partition
  discard execCmd(&"{mke2fs} {Mke2fs} ext4 {partition}")

  createDir(path)

  discard execCmd(&"{mount} {partition} {path} {shellRedirect}")

  # Remove `/lost+found` dir
  removeDir(path / $lostFound)

  discard rsync(getEnv($CRSD) & DirSep, path, rsyncRelease)

  discard rsync(getEnv($SRCD) & DirSep, path / $radCacheSrc, rsyncRelease)

  discard genInitramfs(path / $boot, true)

  # Install `grub` as the default bootloader
  createDir(path / $boot / $grub)

  discard rsync($radLibClustersGlaucus / $grub / $grubCfgImg, path / $boot / $grub / $grubCfg, rsyncRelease)

  discard execCmd(&"{grubInstall} {Grub} --boot-directory={path / $boot} --target=i386-pc {device} {shellRedirect}")

  # Change ownerships
  discard execCmd(&"{chown} {Chown} 0:0 {path} {shellRedirect}")
  discard execCmd(&"{chown} {Chown} 20:20 {path / $VAR / $log / $wtmpd} {shellRedirect}")

  # Clean up
  discard execCmd(&"{umount} {Umount} {path} {shellRedirect}")
  discard execCmd(&"{partx} -d {partition} {shellRedirect}")
  discard execCmd(&"{losetup} -d {device} {shellRedirect}")

proc releaseIso*() =
  let
    iso = getEnv($GLAD) / &"""{glaucus}-{s6}-{x86_64_v3}-{now().format("YYYYMMdd")}{CurDir}{iso}"""

    path = getEnv($ISOD) / $boot

  # Install `grub` as the default bootloader
  removeDir(getEnv($ISOD))
  createDir(path / $grub)

  discard rsync($radLibClustersGlaucus / $grub / $grubCfgIso, path / $grub / $grubCfg)

  discard rsync(getEnv($GLAD) / $initramfs, path)

  # Compress rootfs
  discard execCmd(&"{mkfsErofs} {path / $rootfs} {getEnv($CRSD)} {shellRedirect}")

  # Copy kernel
  discard rsync(getEnv($CRSD) / $boot / $kernel, path)

  # Create a new ISO file
  discard execCmd(&"{grubMkrescue} {Grub} -v -o {iso} {getEnv($ISOD)} -volid {glaucus} {shellRedirect}")

proc setEnvBootstrap*() =
  let path = parentDir(getCurrentDir())

  putEnv($GLAD, path)

  putEnv($BAKD, path / $bak)
  putEnv($CERD, path / $radCerata.cerata)
  putEnv($CRSD, path / $cross)
  putEnv($ISOD, path / $iso)
  putEnv($LOGD, path / $log)
  putEnv($SRCD, path / $src)
  putEnv($TBLD, path / $tmp / $bld)
  putEnv($TSRC, path / $tmp / $src)
  putEnv($TLCD, path / $toolchain)

  putEnv($PATH, getEnv($TLCD) / $usr / &"{bin}{PathSep}{getEnv($PATH)}")

proc setEnvCrossPkgConfig*() =
  putEnv($PKG_CONFIG_LIBDIR, getEnv($CRSD) / $pkgConfigLibdir)
  putEnv($PKG_CONFIG_PATH, getEnv($PKG_CONFIG_LIBDIR))
  putEnv($PKG_CONFIG_SYSROOT_DIR, getEnv($CRSD) & DirSep)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv($PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv($CRSD) / $pkgConfigSystemIncludePath)
  putEnv($PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv($CRSD) / $pkgConfigSystemLibraryPath)

proc setEnvCrossTools*() =
  let crossCompile = getEnv($TGT) & '-'

  putEnv($CROSS_COMPILE, crossCompile)

  putEnv($AR, crossCompile & $ar)
  putEnv($radEnv.AS, crossCompile & $radTools.As)
  putEnv($CC, crossCompile & $gcc)
  putEnv($radEnv.CPP, &"{getEnv($CC)} {cpp}")
  putEnv($CXX, crossCompile & $cxx)
  putEnv($CXXCPP, &"{getEnv($CXX)} {cpp}")
  putEnv($HOSTCC, $gcc)
  putEnv($NM, crossCompile & $nm)
  putEnv($OBJCOPY, crossCompile & $objcopy)
  putEnv($OBJDUMP, crossCompile & $objdump)
  putEnv($RANLIB, crossCompile & $ranlib)
  putEnv($READELF, crossCompile & $readelf)
  putEnv($SIZE, crossCompile & $size)
  putEnv($STRIP, crossCompile & $strip)

proc setEnvNativeDirs*() =
  putEnv($SRCD, $radCacheSrc)
  putEnv($CERD, $radLibClustersGlaucus)
  putEnv($LOGD, $radLog)
  putEnv($TBLD, $radTmp / $bld)
  putEnv($TSRC, $radTmp / $src)

proc setEnvNativePkgConfig*() =
  putEnv($PKG_CONFIG_LIBDIR, $pkgConfigLibdir)
  putEnv($PKG_CONFIG_PATH, $pkgConfigLibdir)
  putEnv($PKG_CONFIG_SYSROOT_DIR, $DirSep)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv($PKG_CONFIG_SYSTEM_INCLUDE_PATH, $pkgConfigSystemIncludePath)
  putEnv($PKG_CONFIG_SYSTEM_LIBRARY_PATH, $pkgConfigSystemLibraryPath)

proc setEnvNativeTools*() =
  putEnv($radEnv.BOOTSTRAP, "yes")

  putEnv($AR, $ar)
  putEnv($radEnv.AS, $radTools.As)
  putEnv($CC, $gcc)
  putEnv($radEnv.CPP, &"{gcc} {cpp}")
  putEnv($CXX, $cxx)
  putEnv($CXXCPP, &"{cxx} {cpp}")
  putEnv($HOSTCC, $gcc)
  putEnv($NM, $nm)
  putEnv($OBJCOPY, $objcopy)
  putEnv($OBJDUMP, $objdump)
  putEnv($RANLIB, $ranlib)
  putEnv($READELF, $readelf)
  putEnv($SIZE, $size)
  putEnv($STRIP, $strip)
