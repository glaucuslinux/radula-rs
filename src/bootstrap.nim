# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, terminal, times],
  ceras, constants, teeth

proc rad_bootstrap_clean*() =
  removeDir(getEnv(RAD_ENV_DIR_CRSD))
  removeDir(getEnv(RAD_ENV_DIR_LOGD))
  removeDir(getEnv(RAD_ENV_DIR_TBLD))
  removeDir(getEnv(RAD_ENV_DIR_TLCD))

func rad_bootstrap_cross_backup*() =
  discard rad_rsync(getEnv(RAD_ENV_DIR_LOGD), getEnv(RAD_ENV_DIR_BAKD))

proc rad_bootstrap_cross_build*() =
  rad_ceras_build([
    # Filesystem
    RAD_CERAS_FILESYSTEM,

    # Package Management
    RAD_CERAS_CERATA,
    RAD_CERAS_RAD,

    # Compatibility
    RAD_CERAS_MUSL_FTS,
    RAD_CERAS_MUSL_UTILS,
    RAD_CERAS_LINUX_HEADERS,

    # Init
    RAD_CERAS_SKALIBS,
    RAD_CERAS_NSSS,
    RAD_CERAS_EXECLINE,
    RAD_CERAS_MDEVD,
    RAD_CERAS_S6,
    RAD_CERAS_UTMPS,

    # Permissions & Capabilities
    RAD_CERAS_ATTR,
    RAD_CERAS_ACL,
    RAD_CERAS_LIBCAP,
    RAD_CERAS_LIBCAP_NG,
    RAD_CERAS_SHADOW,

    # Hashing
    RAD_CERAS_LIBRESSL,
    RAD_CERAS_XXHASH,

    # Userland
    RAD_CERAS_TOYBOX,
    RAD_CERAS_DIFFUTILS,
    RAD_CERAS_FILE,
    RAD_CERAS_FINDUTILS,
    RAD_CERAS_SED,

    # Development
    RAD_CERAS_EXPAT,

    # Compression
    RAD_CERAS_BZIP2,
    RAD_CERAS_LZ4,
    RAD_CERAS_XZ,
    RAD_CERAS_ZLIB_NG,
    RAD_CERAS_PIGZ,
    RAD_CERAS_ZSTD,
    RAD_CERAS_LIBARCHIVE,

    # Development
    RAD_CERAS_AUTOCONF,
    RAD_CERAS_AUTOMAKE,
    RAD_CERAS_BINUTILS,
    RAD_CERAS_BYACC,
    RAD_CERAS_FLEX,
    RAD_CERAS_GCC,
    RAD_CERAS_GETTEXT_TINY,
    RAD_CERAS_HELP2MAN,
    RAD_CERAS_LIBTOOL,
    RAD_CERAS_M4,
    RAD_CERAS_MAKE,
    RAD_CERAS_MAWK,
    RAD_CERAS_PATCH,
    RAD_CERAS_PKGCONF,
    RAD_CERAS_MUON,
    RAD_CERAS_RSYNC,
    RAD_CERAS_SAMURAI,

    # Editors, Pagers and Shells
    RAD_CERAS_NETBSD_CURSES,
    RAD_CERAS_LIBEDIT,
    RAD_CERAS_PCRE2,
    RAD_CERAS_BASH,

    # Userland
    RAD_CERAS_GREP,

    # Utilities
    RAD_CERAS_KMOD,
    RAD_CERAS_LIBUDEV_ZERO,
    RAD_CERAS_PROCPS_NG,
    RAD_CERAS_PSMISC,
    RAD_CERAS_UTIL_LINUX,
    RAD_CERAS_E2FSPROGS,

    # Services
    RAD_CERAS_S6_LINUX_INIT,
    RAD_CERAS_S6_RC,
    RAD_CERAS_S6_BOOT_SCRIPTS,

    # Kernel
    RAD_CERAS_LINUX
  ], RAD_DIR_CROSS, false)

proc rad_bootstrap_cross_env_pkg_config*() =
  putEnv(RAD_ENV_PKG_CONFIG_LIBDIR, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_LIBDIR)
  putEnv(RAD_ENV_PKG_CONFIG_PATH, getEnv(RAD_ENV_PKG_CONFIG_LIBDIR))
  putEnv(RAD_ENV_PKG_CONFIG_SYSROOT_DIR, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_SYSROOT_DIR)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc rad_bootstrap_cross_env_teeth*() =
  let cross_compile = getEnv(RAD_ENV_TUPLE_TGT) & '-'

  putEnv(RAD_ENV_CROSS_COMPILE, cross_compile)

  putEnv(RAD_ENV_TOOTH_AR, cross_compile & RAD_TOOTH_AR)
  putEnv(RAD_ENV_TOOTH_AS, cross_compile & RAD_TOOTH_AS)
  putEnv(RAD_ENV_TOOTH_CC, cross_compile & RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOTH_CPP, cross_compile & RAD_CERAS_GCC & ' ' & RAD_FLAGS_TOOTH_CPP)
  putEnv(RAD_ENV_TOOTH_CXX, cross_compile & RAD_TOOTH_CXX)
  putEnv(RAD_ENV_TOOTH_CXXCPP, cross_compile & RAD_TOOTH_CXX & ' ' & RAD_FLAGS_TOOTH_CPP)
  putEnv(RAD_ENV_TOOTH_HOSTCC, RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOTH_NM, cross_compile & RAD_TOOTH_NM)
  putEnv(RAD_ENV_TOOTH_OBJCOPY, cross_compile & RAD_TOOTH_OBJCOPY)
  putEnv(RAD_ENV_TOOTH_OBJDUMP, cross_compile & RAD_TOOTH_OBJDUMP)
  putEnv(RAD_ENV_TOOTH_RANLIB, cross_compile & RAD_TOOTH_RANLIB)
  putEnv(RAD_ENV_TOOTH_READELF, cross_compile & RAD_TOOTH_READELF)
  putEnv(RAD_ENV_TOOTH_SIZE, cross_compile & RAD_TOOTH_SIZE)
  putEnv(RAD_ENV_TOOTH_STRIP, cross_compile & RAD_TOOTH_STRIP)

proc rad_bootstrap_cross_prepare*() =
  discard rad_rsync(getEnv(RAD_ENV_DIR_BAKD) / RAD_DIR_CROSS, getEnv(RAD_ENV_DIR_GLAD))

  removeDir(getEnv(RAD_ENV_DIR_TBLD))
  createDir(getEnv(RAD_ENV_DIR_TBLD))

  removeFile(getEnv(RAD_ENV_DIR_LOGD) / RAD_DIR_CROSS & CurDir & RAD_DIR_LOG)

proc rad_bootstrap_distclean*() =
  removeDir(getEnv(RAD_ENV_DIR_BAKD))

  rad_bootstrap_clean()

  removeDir(getEnv(RAD_ENV_DIR_SRCD))
  removeDir(getEnv(RAD_ENV_DIR_GLAD) / RAD_DIR_TMP)

proc rad_bootstrap_env*() =
  let path = parentDir(getCurrentDir())

  putEnv(RAD_ENV_DIR_GLAD, path)

  putEnv(RAD_ENV_DIR_BAKD, path / RAD_DIR_BAK)
  putEnv(RAD_ENV_DIR_SRCD, path / RAD_DIR_SRC)
  putEnv(RAD_ENV_DIR_CERD, path / RAD_DIR_CERATA)
  putEnv(RAD_ENV_DIR_CRSD, path / RAD_DIR_CROSS)
  putEnv(RAD_ENV_DIR_ISOD, path / RAD_DIR_ISO)
  putEnv(RAD_ENV_DIR_LOGD, path / RAD_DIR_LOG)
  putEnv(RAD_ENV_DIR_TBLD, path / RAD_DIR_TMP / RAD_DIR_BLD)
  putEnv(RAD_ENV_DIR_TSRC, path / RAD_DIR_TMP / RAD_DIR_SRC)
  putEnv(RAD_ENV_DIR_TLCD, path / RAD_DIR_TOOLCHAIN)

  putEnv(RAD_ENV_PATH, getEnv(RAD_ENV_DIR_TLCD) / RAD_PATH_USR / RAD_PATH_BIN & ':' & getEnv(RAD_ENV_PATH))

proc rad_bootstrap_init*() =
  createDir(getEnv(RAD_ENV_DIR_BAKD))
  createDir(getEnv(RAD_ENV_DIR_CRSD))
  createDir(getEnv(RAD_ENV_DIR_SRCD))
  createDir(getEnv(RAD_ENV_DIR_LOGD))
  createDir(getEnv(RAD_ENV_DIR_TBLD))
  createDir(getEnv(RAD_ENV_DIR_TSRC))
  createDir(getEnv(RAD_ENV_DIR_TLCD))

proc rad_bootstrap_release_img*() =
  if not isAdmin():
    styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"permission denied\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

    rad_exit(QuitFailure)

  let img = getEnv(RAD_ENV_DIR_GLAD) / &"{RAD_DIR_GLAUCUS}-{RAD_CERAS_S6}-{RAD_GENOME_X86_64_V3}-{now().format(\"YYYYMMdd\")}.img"

  # Create a new IMG file
  discard execCmd(&"{RAD_TOOTH_DD} bs=1M count={RAD_FILE_GLAUCUS_IMG_SIZE} if=/dev/zero of={img} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Partition the IMG file
  discard execCmd(&"{RAD_TOOTH_PARTED} {RAD_FLAGS_TOOTH_PARTED} {img} mklabel msdos {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOTH_PARTED} {RAD_FLAGS_TOOTH_PARTED} -a none {img} mkpart primary ext4 1 {RAD_FILE_GLAUCUS_IMG_SIZE} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOTH_PARTED} {RAD_FLAGS_TOOTH_PARTED} -a none {img} set 1 boot on {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Load the `loop` module
  discard execCmd(&"{RAD_TOOTH_MODPROBE} loop {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Detach all used loop devices
  discard execCmd(&"{RAD_TOOTH_LOSETUP} -D {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Find the first unused loop device
  let
    device = execCmdEx(&"{RAD_TOOTH_LOSETUP} -f")[0].strip()
    partition = device & "p1"

  # Associate the first unused loop device with the IMG file
  discard execCmd(&"{RAD_TOOTH_LOSETUP} {device} {img} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Notify the kernel about the new partition on the IMG file
  discard execCmd(&"{RAD_TOOTH_PARTX} -a {device} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Create an `ext4` file system in the partition
  discard execCmd(&"{RAD_TOOTH_MKE2FS} {RAD_FLAGS_TOOTH_MKE2FS} ext4 {partition}")

  let mount = RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_PATH_MNT / RAD_DIR_GLAUCUS

  createDir(mount)

  discard execCmd(&"{RAD_TOOTH_MOUNT} {partition} {mount} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Remove `/lost+found` directory
  removeDir(mount / RAD_PATH_LOST_FOUND)

  discard rad_rsync(getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_SYSROOT_DIR, mount, RAD_FLAGS_TOOTH_RSYNC_RELEASE)

  discard rad_rsync(getEnv(RAD_ENV_DIR_SRCD) / RAD_PATH_PKG_CONFIG_SYSROOT_DIR, mount / RAD_PATH_RAD_CACHE_SRC, RAD_FLAGS_TOOTH_RSYNC_RELEASE)

  let path = mount / RAD_PATH_BOOT

  # Generate initramfs
  discard rad_gen_initramfs(path, true)

  # Install `grub` as the default bootloader
  createDir(path / RAD_CERAS_GRUB)

  discard rad_rsync(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG_IMG, path / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG, RAD_FLAGS_TOOTH_RSYNC_RELEASE)

  discard execCmd(&"{RAD_TOOTH_GRUB_INSTALL} {RAD_FLAGS_TOOTH_GRUB} --boot-directory={mount / RAD_PATH_BOOT} --target=i386-pc {device} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Change ownerships
  discard execCmd(&"{RAD_TOOTH_CHOWN} {RAD_FLAGS_TOOTH_CHOWN} 0:0 {mount} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOTH_CHOWN} {RAD_FLAGS_TOOTH_CHOWN} 20:20 {mount / RAD_PATH_VAR / RAD_DIR_LOG / RAD_PATH_WTMPD} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Clean up
  discard execCmd(&"{RAD_TOOTH_UMOUNT} {RAD_FLAGS_TOOTH_UMOUNT} {mount} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOTH_PARTX} -d {partition} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOTH_LOSETUP} -d {device} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

proc rad_bootstrap_release_iso*() =
  let
    name = &"{RAD_DIR_GLAUCUS}-{RAD_CERAS_S6}-{RAD_GENOME_X86_64_V3}-{now().format(\"YYYYMMdd\")}"
    iso = getEnv(RAD_ENV_DIR_GLAD) / &"{name}.iso"

    path = getEnv(RAD_ENV_DIR_ISOD) / RAD_PATH_BOOT

  # Install `grub` as the default bootloader
  removeDir(getEnv(RAD_ENV_DIR_ISOD))
  createDir(path / RAD_CERAS_GRUB)

  discard rad_rsync(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG_ISO, path / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG)

  # Generate initramfs
  discard rad_rsync(getEnv(RAD_ENV_DIR_GLAD) / RAD_FILE_INITRAMFS, path)

  # Compress rootfs
  discard execCmd(&"{RAD_TOOTH_MKFS_EROFS} {path / RAD_FILE_ROOTFS} {getEnv(RAD_ENV_DIR_CRSD)} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

  # Copy kernel
  discard rad_rsync(getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_BOOT / RAD_FILE_KERNEL, path)

  # Create a new ISO file
  discard execCmd(&"{RAD_TOOTH_GRUB_MKRESCUE} {RAD_FLAGS_TOOTH_GRUB} -v -o {iso} {getEnv(RAD_ENV_DIR_ISOD)} -volid GLAUCUS {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

proc rad_bootstrap_system_env_dir*() =
  putEnv(RAD_ENV_DIR_SRCD, RAD_PATH_RAD_CACHE_SRC)
  putEnv(RAD_ENV_DIR_CERD, RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS)
  putEnv(RAD_ENV_DIR_LOGD, RAD_PATH_RAD_LOG)

  putEnv(RAD_ENV_DIR_TBLD, RAD_PATH_RAD_TMP / RAD_DIR_BLD)
  putEnv(RAD_ENV_DIR_TSRC, RAD_PATH_RAD_TMP / RAD_DIR_SRC)

proc rad_bootstrap_system_env_pkg_config*() =
  putEnv(RAD_ENV_PKG_CONFIG_LIBDIR, RAD_PATH_PKG_CONFIG_LIBDIR)
  putEnv(RAD_ENV_PKG_CONFIG_PATH, getEnv(RAD_ENV_PKG_CONFIG_LIBDIR))
  putEnv(RAD_ENV_PKG_CONFIG_SYSROOT_DIR, RAD_PATH_PKG_CONFIG_SYSROOT_DIR)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_INCLUDE_PATH, RAD_PATH_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_LIBRARY_PATH, RAD_PATH_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc rad_bootstrap_system_env_teeth*() =
  putEnv(RAD_ENV_BOOTSTRAP, "yes")

  putEnv(RAD_ENV_TOOTH_AR, RAD_TOOTH_AR)
  putEnv(RAD_ENV_TOOTH_AS, RAD_TOOTH_AS)
  putEnv(RAD_ENV_TOOTH_CC, RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOTH_CPP, RAD_CERAS_GCC & ' ' & RAD_FLAGS_TOOTH_CPP)
  putEnv(RAD_ENV_TOOTH_CXX, RAD_TOOTH_CXX)
  putEnv(RAD_ENV_TOOTH_CXXCPP, RAD_TOOTH_CXX & ' ' & RAD_FLAGS_TOOTH_CPP)
  putEnv(RAD_ENV_TOOTH_HOSTCC, RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOTH_NM, RAD_TOOTH_NM)
  putEnv(RAD_ENV_TOOTH_OBJCOPY, RAD_TOOTH_OBJCOPY)
  putEnv(RAD_ENV_TOOTH_OBJDUMP, RAD_TOOTH_OBJDUMP)
  putEnv(RAD_ENV_TOOTH_RANLIB, RAD_TOOTH_RANLIB)
  putEnv(RAD_ENV_TOOTH_READELF, RAD_TOOTH_READELF)
  putEnv(RAD_ENV_TOOTH_SIZE, RAD_TOOTH_SIZE)
  putEnv(RAD_ENV_TOOTH_STRIP, RAD_TOOTH_STRIP)

proc rad_bootstrap_system_prepare*() =
  removeDir(getEnv(RAD_ENV_DIR_TBLD))
  createDir(getEnv(RAD_ENV_DIR_TBLD))

  # Create the `src` directory if it doesn't exist, but don't remove it if it does exist!
  createDir(getEnv(RAD_ENV_DIR_TSRC))

  removeFile(getEnv(RAD_ENV_DIR_LOGD) / RAD_DIR_SYSTEM & CurDir & RAD_DIR_LOG)

proc rad_bootstrap_system_build*() =
  rad_ceras_build([
    # Filesystem
    RAD_CERAS_FILESYSTEM,

    # Development
    RAD_CERAS_MUSL,
    RAD_CERAS_CMAKE,
    RAD_CERAS_GMP,
    RAD_CERAS_MPFR,
    RAD_CERAS_MPC,
    RAD_CERAS_ISL,
    RAD_CERAS_PERL,
    RAD_CERAS_TEXINFO,

    # Package Management
    RAD_CERAS_CERATA,
    RAD_CERAS_RAD,

    # Compatibility
    RAD_CERAS_MUSL_FTS,
    RAD_CERAS_LINUX_HEADERS,

    # Permissions & Capabilities
    RAD_CERAS_ATTR,
    RAD_CERAS_ACL,
    RAD_CERAS_LIBCAP,
    RAD_CERAS_LIBCAP_NG,
    RAD_CERAS_OPENDOAS,
    RAD_CERAS_SHADOW,

    # Hashing
    RAD_CERAS_LIBRESSL,
    RAD_CERAS_XXHASH,

    # Userland
    RAD_CERAS_DIFFUTILS,
    RAD_CERAS_FILE,
    RAD_CERAS_FINDUTILS,
    RAD_CERAS_GREP,
    RAD_CERAS_SED,
    RAD_CERAS_TOYBOX,

    # Compression
    RAD_CERAS_BZIP2,
    RAD_CERAS_LZ4,
    RAD_CERAS_XZ,
    RAD_CERAS_ZLIB_NG,
    RAD_CERAS_PIGZ,
    RAD_CERAS_ZSTD,
    RAD_CERAS_LIBARCHIVE,

    # Development
    RAD_CERAS_AUTOCONF,
    RAD_CERAS_AUTOMAKE,
    RAD_CERAS_BINUTILS,
    RAD_CERAS_BYACC,
    RAD_CERAS_EXPAT,
    RAD_CERAS_FLEX,
    RAD_CERAS_GCC,
    RAD_CERAS_GETTEXT_TINY,
    RAD_CERAS_HELP2MAN,
    RAD_CERAS_LIBTOOL,
    RAD_CERAS_M4,
    RAD_CERAS_MAKE,
    RAD_CERAS_MAWK,
    RAD_CERAS_PATCH,
    RAD_CERAS_PKGCONF,
    RAD_CERAS_RSYNC,
    RAD_CERAS_SAMURAI,

    # Editors, Pagers and Shells
    RAD_CERAS_NETBSD_CURSES,
    RAD_CERAS_LIBEDIT,
    RAD_CERAS_PCRE2,
    RAD_CERAS_BASH,
    RAD_CERAS_YASH,
    RAD_CERAS_LESS,
    RAD_CERAS_MANDOC,
    RAD_CERAS_VIM,

    # Networking
    RAD_CERAS_IPROUTE2,
    RAD_CERAS_IPUTILS,
    RAD_CERAS_SDHCP,
    RAD_CERAS_WGET2,

    # Utilities
    RAD_CERAS_KBD,
    RAD_CERAS_KMOD,
    RAD_CERAS_LIBUDEV_ZERO,
    RAD_CERAS_PROCPS_NG,
    RAD_CERAS_PSMISC,
    RAD_CERAS_UTIL_LINUX,
    RAD_CERAS_E2FSPROGS,

    # Init & Services
    RAD_CERAS_SKALIBS,
    RAD_CERAS_NSSS,
    RAD_CERAS_EXECLINE,
    RAD_CERAS_MDEVD,
    RAD_CERAS_S6,
    RAD_CERAS_UTMPS,
    RAD_CERAS_S6_LINUX_INIT,
    RAD_CERAS_S6_RC,
    RAD_CERAS_S6_BOOT_SCRIPTS,

    # Kernel
    RAD_CERAS_LINUX
  ], RAD_DIR_SYSTEM, false)

func rad_bootstrap_toolchain_backup*() =
  discard rad_rsync(getEnv(RAD_ENV_DIR_CRSD), getEnv(RAD_ENV_DIR_BAKD))
  discard rad_rsync(getEnv(RAD_ENV_DIR_LOGD), getEnv(RAD_ENV_DIR_BAKD))

proc rad_bootstrap_toolchain_build*() =
  rad_ceras_build([
    RAD_CERAS_MUSL_HEADERS,
    RAD_CERAS_BINUTILS,
    RAD_CERAS_GCC,
    RAD_CERAS_MUSL,
    RAD_CERAS_LIBGCC,
    RAD_CERAS_LIBSTDCXX_V3
  ], RAD_DIR_TOOLCHAIN, false)
