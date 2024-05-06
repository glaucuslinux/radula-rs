# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  cerata, constants, tools

proc rad_bootstrap_clean*() =
  removeDir(getEnv(RAD_ENV_DIR_CRSD))
  removeDir(getEnv(RAD_ENV_DIR_LOGD))
  removeDir(getEnv(RAD_ENV_DIR_TBLD))
  removeDir(getEnv(RAD_ENV_DIR_TLCD))

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
  ], RAD_STAGE_CROSS, false)

proc rad_bootstrap_cross_env_pkg_config*() =
  putEnv(RAD_ENV_PKG_CONFIG_LIBDIR, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_LIBDIR)
  putEnv(RAD_ENV_PKG_CONFIG_PATH, getEnv(RAD_ENV_PKG_CONFIG_LIBDIR))
  putEnv(RAD_ENV_PKG_CONFIG_SYSROOT_DIR, getEnv(RAD_ENV_DIR_CRSD) & DirSep)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc rad_bootstrap_cross_env_tools*() =
  let cross_compile = getEnv(RAD_ENV_TUPLE_TGT) & '-'

  putEnv(RAD_ENV_CROSS_COMPILE, cross_compile)

  putEnv(RAD_ENV_TOOL_AR, cross_compile & RAD_TOOL_AR)
  putEnv(RAD_ENV_TOOL_AS, cross_compile & RAD_TOOL_AS)
  putEnv(RAD_ENV_TOOL_CC, cross_compile & RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOL_CPP, cross_compile & RAD_CERAS_GCC & ' ' & RAD_FLAGS_TOOL_CPP)
  putEnv(RAD_ENV_TOOL_CXX, cross_compile & RAD_TOOL_CXX)
  putEnv(RAD_ENV_TOOL_CXXCPP, cross_compile & RAD_TOOL_CXX & ' ' & RAD_FLAGS_TOOL_CPP)
  putEnv(RAD_ENV_TOOL_HOSTCC, RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOL_NM, cross_compile & RAD_TOOL_NM)
  putEnv(RAD_ENV_TOOL_OBJCOPY, cross_compile & RAD_TOOL_OBJCOPY)
  putEnv(RAD_ENV_TOOL_OBJDUMP, cross_compile & RAD_TOOL_OBJDUMP)
  putEnv(RAD_ENV_TOOL_RANLIB, cross_compile & RAD_TOOL_RANLIB)
  putEnv(RAD_ENV_TOOL_READELF, cross_compile & RAD_TOOL_READELF)
  putEnv(RAD_ENV_TOOL_SIZE, cross_compile & RAD_TOOL_SIZE)
  putEnv(RAD_ENV_TOOL_STRIP, cross_compile & RAD_TOOL_STRIP)

proc rad_bootstrap_cross_prepare*() =
  discard rad_rsync(getEnv(RAD_ENV_DIR_BAKD) / RAD_STAGE_CROSS, getEnv(RAD_ENV_DIR_GLAD))

  removeDir(getEnv(RAD_ENV_DIR_TBLD))
  createDir(getEnv(RAD_ENV_DIR_TBLD))

proc rad_bootstrap_distclean*() =
  removeDir(getEnv(RAD_ENV_DIR_BAKD))

  rad_bootstrap_clean()

  removeDir(getEnv(RAD_ENV_DIR_SRCD))
  removeDir(getEnv(RAD_ENV_DIR_GLAD) / RAD_DIR_TMP)

proc rad_bootstrap_env*() =
  let path = parentDir(getCurrentDir())

  putEnv(RAD_ENV_DIR_GLAD, path)

  putEnv(RAD_ENV_DIR_BAKD, path / RAD_DIR_BAK)
  putEnv(RAD_ENV_DIR_CERD, path / RAD_DIR_CERATA)
  putEnv(RAD_ENV_DIR_CRSD, path / RAD_STAGE_CROSS)
  putEnv(RAD_ENV_DIR_ISOD, path / RAD_DIR_ISO)
  putEnv(RAD_ENV_DIR_LOGD, path / RAD_DIR_LOG)
  putEnv(RAD_ENV_DIR_SRCD, path / RAD_DIR_SRC)
  putEnv(RAD_ENV_DIR_TBLD, path / RAD_DIR_TMP / RAD_DIR_BLD)
  putEnv(RAD_ENV_DIR_TSRC, path / RAD_DIR_TMP / RAD_DIR_SRC)
  putEnv(RAD_ENV_DIR_TLCD, path / RAD_STAGE_TOOLCHAIN)

  putEnv(RAD_ENV_PATH, getEnv(RAD_ENV_DIR_TLCD) / RAD_PATH_USR / RAD_PATH_BIN & PathSep & getEnv(RAD_ENV_PATH))

proc rad_bootstrap_init*() =
  createDir(getEnv(RAD_ENV_DIR_BAKD))
  createDir(getEnv(RAD_ENV_DIR_CRSD))
  createDir(getEnv(RAD_ENV_DIR_LOGD))
  createDir(getEnv(RAD_ENV_DIR_SRCD))
  createDir(getEnv(RAD_ENV_DIR_TBLD))
  createDir(getEnv(RAD_ENV_DIR_TSRC))
  createDir(getEnv(RAD_ENV_DIR_TLCD))

proc rad_bootstrap_native_env_dir*() =
  putEnv(RAD_ENV_DIR_SRCD, RAD_PATH_RAD_CACHE_SRC)
  putEnv(RAD_ENV_DIR_CERD, RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS)
  putEnv(RAD_ENV_DIR_LOGD, RAD_PATH_RAD_LOG)
  putEnv(RAD_ENV_DIR_TBLD, RAD_PATH_RAD_TMP / RAD_DIR_BLD)
  putEnv(RAD_ENV_DIR_TSRC, RAD_PATH_RAD_TMP / RAD_DIR_SRC)

proc rad_bootstrap_native_env_pkg_config*() =
  putEnv(RAD_ENV_PKG_CONFIG_LIBDIR, RAD_PATH_PKG_CONFIG_LIBDIR)
  putEnv(RAD_ENV_PKG_CONFIG_PATH, getEnv(RAD_ENV_PKG_CONFIG_LIBDIR))
  putEnv(RAD_ENV_PKG_CONFIG_SYSROOT_DIR, $DirSep)

  # These env variables are `pkgconf` specific, but setting them won't
  # do any harm...
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_INCLUDE_PATH, RAD_PATH_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
  putEnv(RAD_ENV_PKG_CONFIG_SYSTEM_LIBRARY_PATH, RAD_PATH_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc rad_bootstrap_native_env_tools*() =
  putEnv(RAD_ENV_BOOTSTRAP, "yes")

  putEnv(RAD_ENV_TOOL_AR, RAD_TOOL_AR)
  putEnv(RAD_ENV_TOOL_AS, RAD_TOOL_AS)
  putEnv(RAD_ENV_TOOL_CC, RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOL_CPP, RAD_CERAS_GCC & ' ' & RAD_FLAGS_TOOL_CPP)
  putEnv(RAD_ENV_TOOL_CXX, RAD_TOOL_CXX)
  putEnv(RAD_ENV_TOOL_CXXCPP, RAD_TOOL_CXX & ' ' & RAD_FLAGS_TOOL_CPP)
  putEnv(RAD_ENV_TOOL_HOSTCC, RAD_CERAS_GCC)
  putEnv(RAD_ENV_TOOL_NM, RAD_TOOL_NM)
  putEnv(RAD_ENV_TOOL_OBJCOPY, RAD_TOOL_OBJCOPY)
  putEnv(RAD_ENV_TOOL_OBJDUMP, RAD_TOOL_OBJDUMP)
  putEnv(RAD_ENV_TOOL_RANLIB, RAD_TOOL_RANLIB)
  putEnv(RAD_ENV_TOOL_READELF, RAD_TOOL_READELF)
  putEnv(RAD_ENV_TOOL_SIZE, RAD_TOOL_SIZE)
  putEnv(RAD_ENV_TOOL_STRIP, RAD_TOOL_STRIP)

proc rad_bootstrap_native_prepare*() =
  removeDir(getEnv(RAD_ENV_DIR_TBLD))
  createDir(getEnv(RAD_ENV_DIR_TBLD))

  # Create the `src` dir if it doesn't exist, but don't remove it if it does exist!
  createDir(getEnv(RAD_ENV_DIR_TSRC))

proc rad_bootstrap_native_build*() =
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
  ], RAD_STAGE_NATIVE, false)

proc rad_bootstrap_release_img*() =
  if not isAdmin():
    rad_abort(&"{\"1\":8}{\"permission denied\":48}")

  let
    img = getEnv(RAD_ENV_DIR_GLAD) / &"{RAD_GLAUCUS}-{RAD_CERAS_S6}-{RAD_ARCH_X86_64_V3}-{now().format(\"YYYYMMdd\")}.img"

    # Find the first unused loop device
    device = execCmdEx(&"{RAD_TOOL_LOSETUP} -f")[0].strip()

    partition = device & "p1"

    mount = DirSep & RAD_PATH_MNT / RAD_GLAUCUS

    path = mount / RAD_PATH_BOOT

  # Create a new IMG file
  discard execCmd(&"{RAD_TOOL_DD} bs=1M count={RAD_FILE_GLAUCUS_IMG_SIZE} if=/dev/zero of={img} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Partition the IMG file
  discard execCmd(&"{RAD_TOOL_PARTED} {RAD_FLAGS_TOOL_PARTED} {img} mklabel msdos {RAD_FLAGS_TOOL_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOL_PARTED} {RAD_FLAGS_TOOL_PARTED} -a none {img} mkpart primary ext4 1 {RAD_FILE_GLAUCUS_IMG_SIZE} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOL_PARTED} {RAD_FLAGS_TOOL_PARTED} -a none {img} set 1 boot on {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Load the `loop` module
  discard execCmd(&"{RAD_TOOL_MODPROBE} loop {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Detach all used loop devices
  discard execCmd(&"{RAD_TOOL_LOSETUP} -D {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Associate the first unused loop device with the IMG file
  discard execCmd(&"{RAD_TOOL_LOSETUP} {device} {img} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Notify the kernel about the new partition on the IMG file
  discard execCmd(&"{RAD_TOOL_PARTX} -a {device} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Create an `ext4` filesystem in the partition
  discard execCmd(&"{RAD_TOOL_MKE2FS} {RAD_FLAGS_TOOL_MKE2FS} ext4 {partition}")

  createDir(mount)

  discard execCmd(&"{RAD_TOOL_MOUNT} {partition} {mount} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Remove `/lost+found` dir
  removeDir(mount / RAD_PATH_LOST_FOUND)

  discard rad_rsync(getEnv(RAD_ENV_DIR_CRSD) & DirSep, mount, RAD_FLAGS_TOOL_RSYNC_RELEASE)

  discard rad_rsync(getEnv(RAD_ENV_DIR_SRCD) & DirSep, mount / RAD_PATH_RAD_CACHE_SRC, RAD_FLAGS_TOOL_RSYNC_RELEASE)

  discard rad_gen_initramfs(path, true)

  # Install `grub` as the default bootloader
  createDir(path / RAD_CERAS_GRUB)

  discard rad_rsync(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG_IMG, path / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG, RAD_FLAGS_TOOL_RSYNC_RELEASE)

  discard execCmd(&"{RAD_TOOL_GRUB_INSTALL} {RAD_FLAGS_TOOL_GRUB} --boot-directory={mount / RAD_PATH_BOOT} --target=i386-pc {device} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Change ownerships
  discard execCmd(&"{RAD_TOOL_CHOWN} {RAD_FLAGS_TOOL_CHOWN} 0:0 {mount} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOL_CHOWN} {RAD_FLAGS_TOOL_CHOWN} 20:20 {mount / RAD_PATH_VAR / RAD_DIR_LOG / RAD_PATH_WTMPD} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Clean up
  discard execCmd(&"{RAD_TOOL_UMOUNT} {RAD_FLAGS_TOOL_UMOUNT} {mount} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOL_PARTX} -d {partition} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")
  discard execCmd(&"{RAD_TOOL_LOSETUP} -d {device} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

proc rad_bootstrap_release_iso*() =
  let
    iso = getEnv(RAD_ENV_DIR_GLAD) / &"{RAD_GLAUCUS}-{RAD_CERAS_S6}-{RAD_ARCH_X86_64_V3}-{now().format(\"YYYYMMdd\")}.iso"

    path = getEnv(RAD_ENV_DIR_ISOD) / RAD_PATH_BOOT

  # Install `grub` as the default bootloader
  removeDir(getEnv(RAD_ENV_DIR_ISOD))
  createDir(path / RAD_CERAS_GRUB)

  discard rad_rsync(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG_ISO, path / RAD_CERAS_GRUB / RAD_FILE_GRUB_CFG)

  discard rad_rsync(getEnv(RAD_ENV_DIR_GLAD) / RAD_FILE_INITRAMFS, path)

  # Compress rootfs
  discard execCmd(&"{RAD_TOOL_MKFS_EROFS} {path / RAD_FILE_ROOTFS} {getEnv(RAD_ENV_DIR_CRSD)} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

  # Copy kernel
  discard rad_rsync(getEnv(RAD_ENV_DIR_CRSD) / RAD_PATH_BOOT / RAD_FILE_KERNEL, path)

  # Create a new ISO file
  discard execCmd(&"{RAD_TOOL_GRUB_MKRESCUE} {RAD_FLAGS_TOOL_GRUB} -v -o {iso} {getEnv(RAD_ENV_DIR_ISOD)} -volid GLAUCUS {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

func rad_bootstrap_toolchain_backup*() =
  discard rad_rsync(getEnv(RAD_ENV_DIR_CRSD), getEnv(RAD_ENV_DIR_BAKD))

proc rad_bootstrap_toolchain_build*() =
  rad_ceras_build([
    RAD_CERAS_MUSL_HEADERS,
    RAD_CERAS_BINUTILS,
    RAD_CERAS_GCC,
    RAD_CERAS_MUSL,
    RAD_CERAS_LIBGCC,
    RAD_CERAS_LIBSTDCXX_V3
  ], RAD_STAGE_TOOLCHAIN, false)
