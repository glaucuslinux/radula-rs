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
    $fs,

    # Package Management
    $radCerata.cerata,
    $rad,

    # Compatibility
    $linuxHeaders,
    $muslFts,
    $muslUtils,

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
    $diffutils,
    $file,
    $findutils,
    $sed,
    $toybox,

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

    # Terminal
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
    $fs,
    $ianaEtc,
    $tzcode,
    $tzdata,

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
    $linuxHeaders,
    $muslFts,

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
    $eiwd,
    $iproute2,
    $iputils,
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

    device = execCmdEx(&"{losetup} -f")[0].strip()

    partitionOne = device & "p1"
    partitionTwo = device & "p2"

    path = DirSep & $mnt / $glaucus

  discard execCmd(&"{dd} bs=1M count={imgSize} if=/dev/zero of={img} {shellRedirect}")

  discard execCmd(&"{parted} {Parted} {img} mklabel gpt {shellRedirect}")
  discard execCmd(&"{parted} {Parted} {img} mkpart ESP fat32 1 65 {shellRedirect}")
  discard execCmd(&"{parted} {Parted} {img} set 1 esp on {shellRedirect}")
  discard execCmd(&"{parted} {Parted} {img} mkpart ext4 65 {imgSize} {shellRedirect}")

  discard execCmd(&"{modprobe} loop {shellRedirect}")

  discard execCmd(&"{losetup} -D {shellRedirect}")

  discard execCmd(&"{losetup} {device} {img} {shellRedirect}")

  discard execCmd(&"{partx} -a {device} {shellRedirect}")

  discard execCmd(&"{mkfsFat} -F 32 {partitionOne} {shellRedirect}")
  discard execCmd(&"{mke2fs} {Mke2fs} ext4 {partitionTwo}")

  createDir(path)

  discard execCmd(&"{mount} {partitionTwo} {path} {shellRedirect}")

  discard rsync(getEnv($CRSD) & DirSep, path, rsyncRelease)

  discard rsync(getEnv($SRCD) & DirSep, path / $radCacheSrc, rsyncRelease)

  discard execCmd(&"{mount} {partitionOne} {path / $boot} {shellRedirect}")

  discard genInitramfs(path / $boot, true)

  discard rsync($radLibClustersCerata / $limine / $limineCfgImg, path / $boot / $limineCfg, rsyncRelease)

  discard rsync(DirSep & $boot / $kernelCachyOs, path / $boot / $kernel, rsyncRelease)

  createDir(path / $boot / $efiBoot)
  discard rsync(DirSep & $usr / $share / $limine / $limineEfi, path / $boot / $efiBoot, rsyncRelease)

  discard execCmd(&"{chown} {Chown} 0:0 {path} {shellRedirect}")
  discard execCmd(&"{chown} {Chown} 20:20 {path / $Var / $log / $wtmpd} {shellRedirect}")

  discard execCmd(&"{umount} {Umount} {path / $boot} {shellRedirect}")
  discard execCmd(&"{umount} {Umount} {path} {shellRedirect}")

  discard execCmd(&"{partx} -d {partitionOne} {shellRedirect}")
  discard execCmd(&"{partx} -d {partitionTwo} {shellRedirect}")

  discard execCmd(&"{losetup} -d {device} {shellRedirect}")

proc releaseIso*() =
  let
    iso = getEnv($GLAD) / &"""{glaucus}-{s6}-{x86_64_v3}-{now().format("YYYYMMdd")}{CurDir}{iso}"""

    path = getEnv($ISOD)

  removeDir(path)

  createDir(path / $efiBoot)
  createDir(path / $limine)
  createDir(path / $tmp)

  discard rsync(getEnv($GLAD) / $initramfs, path)

  discard rsync($radLibClustersCerata / $limine / $limineCfgIso, path / $limine / $limineCfg, rsyncRelease)

  discard rsync(DirSep & $usr / $share / $limine / $limineEfi, path / $efiBoot, rsyncRelease)

  discard rsync(DirSep & $usr / $share / $limine / $limineBios, path / $limine, rsyncRelease)
  discard rsync(DirSep & $usr / $share / $limine / $limineBiosCd, path / $limine, rsyncRelease)
  discard rsync(DirSep & $usr / $share / $limine / $limineUefiCd, path / $limine, rsyncRelease)

  discard rsync(DirSep & $boot / $kernelCachyOs, path / $kernel, rsyncRelease)

  installCerata([$skel], getEnv($PKGD), path / $tmp, path / $tmp / $radLibLocal)

  removeDir(path / $tmp / $boot)

  discard execCmd(&"{chown} {Chown} 0:0 {path} {shellRedirect}")
  discard execCmd(&"{chown} {Chown} 20:20 {path / $tmp / $Var / $log / $wtmpd} {shellRedirect}")
  discard execCmd(&"{mkfsErofs} {path / $fs} {path / $tmp} {shellRedirect}")

  removeDir(path / $tmp)

  discard execCmd(&"{xorriso} -as mkisofs -o {iso} -iso-level 3 -l -r -J -joliet-long -hfsplus -apm-block-size 2048 -V {toUpperAscii($glaucus)} -P {glaucus} -A {glaucus} -p {glaucus} -b {$limine / $limineBiosCd} -boot-load-size 4 -no-emul-boot -boot-info-table --efi-boot {$limine / $limineUefiCd} --protective-msdos-label -efi-boot-part --efi-boot-image -vv {path} {shellRedirect}")

  removeDir(path)

  discard execCmd(&"{limine} bios-install {iso} {shellRedirect}")

proc setEnvBootstrap*() =
  let path = parentDir(getCurrentDir())

  putEnv($GLAD, path)

  putEnv($BAKD, path / $bak)
  putEnv($CERD, path / $radCerata.cerata)
  putEnv($CRSD, path / $cross)
  putEnv($ISOD, path / $iso)
  putEnv($LOGD, path / $log)
  putEnv($PKGD, path / $pkg)
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
  putEnv($CERD, $radLibClustersCerata)
  putEnv($LOGD, $radLog)
  putEnv($PKGD, $radCachePkg)
  putEnv($SRCD, $radCacheSrc)
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
