# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  cerata, constants, tools

proc rad_bootstrap_clean*() =
  removeDir(getEnv($CRSD))
  removeDir(getEnv($LOGD))
  removeDir(getEnv($TBLD))
  removeDir(getEnv($TLCD))

proc rad_bootstrap_cross_build*() =
  rad_ceras_build([
    # Filesystem
    $filesystem,

    # Package Management
    $RAD_CERATA.CERATA,
    $rad,

    # Compatibility
    $musl_fts,
    $musl_utils,
    $linux_headers,

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
    $libcap_ng,
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
    $zlib_ng,
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
    $gettext_tiny,
    $help2man,
    $libtool,
    $m4,
    $make,
    $mawk,
    $patch,
    $pkgconf,
    $muon,
    $rsync,
    $samurai,

    # Editors, Pagers and Shells
    $netbsd_curses,
    $libedit,
    $pcre2,
    $bash,

    # Userland
    $grep,

    # Utilities
    $kmod,
    $libudev_zero,
    $procps_ng,
    $psmisc,
    $util_linux,
    $e2fsprogs,

    # Services
    $s6_linux_init,
    $s6_rc,
    $s6_boot_scripts,

    # Kernel
    $linux
  ], $cross, false)

proc rad_bootstrap_cross_env_pkg_config*() =
  putEnv($RAD_ENV.PKG_CONFIG_LIBDIR, getEnv($CRSD) / $RAD_PATHS.PKG_CONFIG_LIBDIR)
  putEnv($PKG_CONFIG_PATH, getEnv($RAD_ENV.PKG_CONFIG_LIBDIR))
  putEnv($PKG_CONFIG_SYSROOT_DIR, getEnv($CRSD) & DirSep)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv($RAD_ENV.PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv($CRSD) / $RAD_PATHS.PKG_CONFIG_SYSTEM_INCLUDE_PATH)
  putEnv($RAD_ENV.PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv($CRSD) / $RAD_PATHS.PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc rad_bootstrap_cross_env_tools*() =
  let cross_compile = getEnv($TGT) & '-'

  putEnv($CROSS_COMPILE, cross_compile)

  putEnv($AR, cross_compile & $ar)
  putEnv($RAD_ENV.AS, cross_compile & $RAD_TOOLS.AS)
  putEnv($CC, cross_compile & $gcc)
  putEnv($RAD_ENV.CPP, &"{getEnv($CC)} {RAD_FLAGS.CPP}")
  putEnv($CXX, cross_compile & $cxx)
  putEnv($CXXCPP, &"{getEnv($CXX)} {RAD_FLAGS.CPP}")
  putEnv($HOSTCC, $gcc)
  putEnv($NM, cross_compile & $nm)
  putEnv($OBJCOPY, cross_compile & $objcopy)
  putEnv($OBJDUMP, cross_compile & $objdump)
  putEnv($RANLIB, cross_compile & $ranlib)
  putEnv($READELF, cross_compile & $readelf)
  putEnv($SIZE, cross_compile & $size)
  putEnv($STRIP, cross_compile & $strip)

proc rad_bootstrap_cross_prepare*() =
  discard rad_rsync(getEnv($BAKD) / $cross, getEnv($GLAD))

  removeDir(getEnv($TBLD))
  createDir(getEnv($TBLD))

proc rad_bootstrap_distclean*() =
  removeDir(getEnv($BAKD))

  rad_bootstrap_clean()

  removeDir(getEnv($SRCD))
  removeDir(getEnv($GLAD) / $tmp)

proc rad_bootstrap_env*() =
  let path = parentDir(getCurrentDir())

  putEnv($GLAD, path)

  putEnv($BAKD, path / $bak)
  putEnv($CERD, path / $RAD_CERATA.CERATA)
  putEnv($CRSD, path / $cross)
  putEnv($ISOD, path / $iso)
  putEnv($LOGD, path / $log)
  putEnv($SRCD, path / $src)
  putEnv($TBLD, path / $tmp / $bld)
  putEnv($TSRC, path / $tmp / $src)
  putEnv($TLCD, path / $toolchain)

  putEnv($PATH, getEnv($TLCD) / $usr / &"{bin}{PathSep}{getEnv($PATH)}")

proc rad_bootstrap_init*() =
  createDir(getEnv($BAKD))
  createDir(getEnv($CRSD))
  createDir(getEnv($LOGD))
  createDir(getEnv($SRCD))
  createDir(getEnv($TBLD))
  createDir(getEnv($TSRC))
  createDir(getEnv($TLCD))

proc rad_bootstrap_native_env_dir*() =
  putEnv($SRCD, $RAD_CACHE_SRC)
  putEnv($CERD, $RAD_LIB_CLUSTERS_GLAUCUS)
  putEnv($LOGD, $RAD_LOG)
  putEnv($TBLD, $RAD_TMP / $bld)
  putEnv($TSRC, $RAD_TMP / $src)

proc rad_bootstrap_native_env_pkg_config*() =
  putEnv($RAD_ENV.PKG_CONFIG_LIBDIR, $RAD_PATHS.PKG_CONFIG_LIBDIR)
  putEnv($PKG_CONFIG_PATH, $RAD_PATHS.PKG_CONFIG_LIBDIR)
  putEnv($PKG_CONFIG_SYSROOT_DIR, $DirSep)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv($RAD_ENV.PKG_CONFIG_SYSTEM_INCLUDE_PATH, $RAD_PATHS.PKG_CONFIG_SYSTEM_INCLUDE_PATH)
  putEnv($RAD_ENV.PKG_CONFIG_SYSTEM_LIBRARY_PATH, $RAD_PATHS.PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc rad_bootstrap_native_env_tools*() =
  putEnv($RAD_ENV.BOOTSTRAP, "yes")

  putEnv($AR, $ar)
  putEnv($RAD_ENV.AS, $RAD_TOOLS.AS)
  putEnv($CC, $gcc)
  putEnv($RAD_ENV.CPP, &"{gcc} {RAD_FLAGS.CPP}")
  putEnv($CXX, $cxx)
  putEnv($CXXCPP, &"{cxx} {RAD_FLAGS.CPP}")
  putEnv($HOSTCC, $gcc)
  putEnv($NM, $nm)
  putEnv($OBJCOPY, $objcopy)
  putEnv($OBJDUMP, $objdump)
  putEnv($RANLIB, $ranlib)
  putEnv($READELF, $readelf)
  putEnv($SIZE, $size)
  putEnv($STRIP, $strip)

proc rad_bootstrap_native_prepare*() =
  removeDir(getEnv($TBLD))
  createDir(getEnv($TBLD))

  # Create the `src` dir if it doesn't exist, but don't remove it if it does exist!
  createDir(getEnv($TSRC))

proc rad_bootstrap_native_build*() =
  rad_ceras_build([
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
    $RAD_CERATA.CERATA,
    $rad,

    # Compatibility
    $musl_fts,
    $linux_headers,

    # Permissions & Capabilities
    $attr,
    $acl,
    $libcap,
    $libcap_ng,
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
    $zlib_ng,
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
    $gettext_tiny,
    $help2man,
    $libtool,
    $m4,
    $make,
    $mawk,
    $patch,
    $pkgconf,
    $rsync,
    $samurai,

    # Editors, Pagers and Shells
    $netbsd_curses,
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
    $libudev_zero,
    $procps_ng,
    $psmisc,
    $util_linux,
    $e2fsprogs,

    # Init & Services
    $skalibs,
    $nsss,
    $execline,
    $mdevd,
    $s6,
    $utmps,
    $s6_linux_init,
    $s6_rc,
    $s6_boot_scripts,

    # Kernel
    $linux
  ], $native, false)

proc rad_bootstrap_release_img*() =
  if not isAdmin():
    rad_abort(&"""{"1":8}{"permission denied":48}""")

  let
    img = getEnv($GLAD) / &"""{glaucus}-{s6}-{X86_64_V3}-{now().format("YYYYMMdd")}{CurDir}img"""

    # Find the first unused loop device
    device = execCmdEx(&"{losetup} -f")[0].strip()

    partition = device & "p1"

    path = DirSep & $mnt / $glaucus

  # Create a new IMG file
  discard execCmd(&"{dd} bs=1M count={img_size} if=/dev/zero of={img} {SHELL_REDIRECT}")

  # Partition the IMG file
  discard execCmd(&"{parted} {PARTED} {img} mklabel msdos {SHELL_REDIRECT}")
  discard execCmd(&"{parted} {PARTED} -a none {img} mkpart primary ext4 1 {img_size} {SHELL_REDIRECT}")
  discard execCmd(&"{parted} {PARTED} -a none {img} set 1 boot on {SHELL_REDIRECT}")

  # Load the `loop` module
  discard execCmd(&"{modprobe} loop {SHELL_REDIRECT}")

  # Detach all used loop devices
  discard execCmd(&"{losetup} -D {SHELL_REDIRECT}")

  # Associate the first unused loop device with the IMG file
  discard execCmd(&"{losetup} {device} {img} {SHELL_REDIRECT}")

  # Notify the kernel about the new partition on the IMG file
  discard execCmd(&"{partx} -a {device} {SHELL_REDIRECT}")

  # Create an `ext4` filesystem in the partition
  discard execCmd(&"{mke2fs} {MKE2FS} ext4 {partition}")

  createDir(path)

  discard execCmd(&"{mount} {partition} {path} {SHELL_REDIRECT}")

  # Remove `/lost+found` dir
  removeDir(path / $lost_found)

  discard rad_rsync(getEnv($CRSD) & DirSep, path, RSYNC_RELEASE)

  discard rad_rsync(getEnv($SRCD) & DirSep, path / $RAD_CACHE_SRC, RSYNC_RELEASE)

  discard rad_gen_initramfs(path / $boot, true)

  # Install `grub` as the default bootloader
  createDir(path / $boot / $grub)

  discard rad_rsync($RAD_LIB_CLUSTERS_GLAUCUS / $grub / $grub_cfg_img, path / $boot / $grub / $grub_cfg, RSYNC_RELEASE)

  discard execCmd(&"{grub_install} {GRUB} --boot-directory={path / $boot} --target=i386-pc {device} {SHELL_REDIRECT}")

  # Change ownerships
  discard execCmd(&"{chown} {CHOWN} 0:0 {path} {SHELL_REDIRECT}")
  discard execCmd(&"{chown} {CHOWN} 20:20 {path / $VAR / $log / $wtmpd} {SHELL_REDIRECT}")

  # Clean up
  discard execCmd(&"{umount} {UMOUNT} {path} {SHELL_REDIRECT}")
  discard execCmd(&"{partx} -d {partition} {SHELL_REDIRECT}")
  discard execCmd(&"{losetup} -d {device} {SHELL_REDIRECT}")

proc rad_bootstrap_release_iso*() =
  let
    iso = getEnv($GLAD) / &"""{glaucus}-{s6}-{X86_64_V3}-{now().format("YYYYMMdd")}{CurDir}{iso}"""

    path = getEnv($ISOD) / $boot

  # Install `grub` as the default bootloader
  removeDir(getEnv($ISOD))
  createDir(path / $grub)

  discard rad_rsync($RAD_LIB_CLUSTERS_GLAUCUS / $grub / $grub_cfg_iso, path / $grub / $grub_cfg)

  discard rad_rsync(getEnv($GLAD) / $initramfs, path)

  # Compress rootfs
  discard execCmd(&"{mkfs_erofs} {path / $rootfs} {getEnv($CRSD)} {SHELL_REDIRECT}")

  # Copy kernel
  discard rad_rsync(getEnv($CRSD) / $boot / $kernel, path)

  # Create a new ISO file
  discard execCmd(&"{grub_mkrescue} {GRUB} -v -o {iso} {getEnv($ISOD)} -volid {glaucus} {SHELL_REDIRECT}")

func rad_bootstrap_toolchain_backup*() =
  discard rad_rsync(getEnv($CRSD), getEnv($BAKD))

proc rad_bootstrap_toolchain_build*() =
  rad_ceras_build([
    $musl_headers,
    $binutils,
    $gcc,
    $musl,
    $libgcc,
    $libstdcxx_v3
  ], $toolchain, false)
