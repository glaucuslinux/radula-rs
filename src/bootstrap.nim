# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    osproc,
    strformat,
    strutils,
    times
]

import
    constants,
    envenomate,
    teeth

proc radula_behave_bootstrap_clean*() =
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS))
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS))
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS))
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_BUILDS))
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN))

proc radula_behave_bootstrap_cross_ccache*() =
    putEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY, getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS) / RADULA_CERAS_CCACHE)
    putEnv(RADULA_ENVIRONMENT_PATH, getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN) / RADULA_PATH_USR / RADULA_PATH_LIB / RADULA_CERAS_CCACHE & ':' & getEnv(RADULA_ENVIRONMENT_PATH))

    createDir(getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY))

proc radula_behave_bootstrap_cross_envenomate*() =
    radula_behave_envenomate([
        # Filesystem & Package Management
        RADULA_CERAS_HYDROSKELETON,
        RADULA_CERAS_IANA_ETC,
        RADULA_CERAS_CERATA,
        RADULA_CERAS_RADULA,

        # Headers
        RADULA_CERAS_MUSL_UTILS,
        RADULA_CERAS_LINUX_HEADERS,

        # Init
        RADULA_CERAS_SKALIBS,
        RADULA_CERAS_NSSS,
        RADULA_CERAS_EXECLINE,
        RADULA_CERAS_S6,
        RADULA_CERAS_UTMPS,

        # Compatibility
        RADULA_CERAS_MUSL_FTS,
        RADULA_CERAS_MUSL_OBSTACK,
        RADULA_CERAS_MUSL_RPMATCH,
        RADULA_CERAS_LIBUCONTEXT,

        # Permissions & Capabilities
        RADULA_CERAS_ATTR,
        RADULA_CERAS_ACL,
        RADULA_CERAS_LIBCAP,
        RADULA_CERAS_LIBCAP_NG,
        RADULA_CERAS_SHADOW,

        # Hashing
        RADULA_CERAS_LIBRESSL,
        RADULA_CERAS_XXHASH,

        # Userland
        RADULA_CERAS_TOYBOX,
        RADULA_CERAS_DIFFUTILS,
        RADULA_CERAS_FILE,
        RADULA_CERAS_FINDUTILS,
        RADULA_CERAS_SED,

        # Development
        RADULA_CERAS_EXPAT,

        # Compression
        RADULA_CERAS_BZIP2,
        RADULA_CERAS_LBZIP2,
        RADULA_CERAS_LBZIP2_UTILS,
        RADULA_CERAS_LZ4,
        RADULA_CERAS_LZLIB,
        RADULA_CERAS_PLZIP,
        RADULA_CERAS_XZ,
        RADULA_CERAS_ZLIB_NG,
        RADULA_CERAS_PIGZ,
        RADULA_CERAS_ZSTD,
        RADULA_CERAS_LIBARCHIVE,

        # Development
        RADULA_CERAS_AUTOCONF,
        RADULA_CERAS_AUTOMAKE,
        RADULA_CERAS_BINUTILS,
        RADULA_CERAS_BYACC,
        RADULA_CERAS_CCACHE,
        # RADULA_CERAS_CMAKE,
        RADULA_CERAS_FLEX,
        RADULA_CERAS_GCC,
        RADULA_CERAS_HELP2MAN,
        RADULA_CERAS_LIBTOOL,
        RADULA_CERAS_MAKE,
        RADULA_CERAS_MAWK,
        RADULA_CERAS_MIMALLOC,
        RADULA_CERAS_MOLD,
        RADULA_CERAS_OM4,
        RADULA_CERAS_PATCH,
        RADULA_CERAS_PKGCONF,
        # RADULA_CERAS_PYTHON,
        RADULA_CERAS_SAMURAI,

        # Synchronization
        RADULA_CERAS_RSYNC,

        # Editors, Pagers and Shells
        RADULA_CERAS_NETBSD_CURSES,
        RADULA_CERAS_LIBEDIT,
        RADULA_CERAS_PCRE2,
        RADULA_CERAS_DASH,
        RADULA_CERAS_YASH,
        RADULA_CERAS_LESS,
        RADULA_CERAS_VIM,
        RADULA_CERAS_MANDOC,

        # Userland
        RADULA_CERAS_BC,
        RADULA_CERAS_GREP,
        RADULA_CERAS_PLOCATE,

        # Networking
        RADULA_CERAS_IPROUTE2,
        RADULA_CERAS_IPUTILS,
        RADULA_CERAS_SDHCP,
        RADULA_CERAS_CURL,
        RADULA_CERAS_WGET2,

        # Time Zone
        RADULA_CERAS_TZCODE,
        RADULA_CERAS_TZDATA,

        # Utilities
        RADULA_CERAS_KMOD,
        RADULA_CERAS_EUDEV,
        RADULA_CERAS_PSMISC,
        RADULA_CERAS_PROCPS_NG,
        RADULA_CERAS_UTIL_LINUX,
        RADULA_CERAS_E2FSPROGS,
        RADULA_CERAS_PCIUTILS,
        RADULA_CERAS_HWDATA,

        # Services
        RADULA_CERAS_S6_LINUX_INIT,
        RADULA_CERAS_S6_RC,
        RADULA_CERAS_S6_BOOT_SCRIPTS,

        # Kernel
        RADULA_CERAS_LIBUARGP,
        RADULA_CERAS_LIBELF,
        # RADULA_CERAS_LINUX
    ], RADULA_DIRECTORY_CROSS, false)

proc radula_behave_bootstrap_cross_environment_directories*() =
    let path = getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY) / RADULA_DIRECTORY_CROSS

    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS, path)

    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS, path / RADULA_DIRECTORY_BUILDS)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_SOURCES, path / RADULA_DIRECTORY_SOURCES)

    # cross log file
    putEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG, getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS) / RADULA_DIRECTORY_CROSS & CurDir & RADULA_DIRECTORY_LOGS)

proc radula_behave_bootstrap_cross_environment_pkg_config*() =
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_LIBDIR, getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_LIBDIR_PATH)
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_PATH, getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_LIBDIR))
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSROOT_DIR, getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_SYSROOT_DIR)

    # These environment variables are only `pkgconf` specific, but setting them
    # won't do any harm...
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

proc radula_behave_bootstrap_cross_environment_teeth*() =
    let cross_compile = getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET) & '-'

    putEnv(RADULA_ENVIRONMENT_CROSS_ARCHIVER, cross_compile & RADULA_CROSS_ARCHIVER)
    putEnv(RADULA_ENVIRONMENT_CROSS_ASSEMBLER, cross_compile & RADULA_CROSS_ASSEMBLER)
    putEnv(RADULA_ENVIRONMENT_CROSS_BUILD_C_COMPILER, RADULA_CROSS_C_COMPILER)
    putEnv(RADULA_ENVIRONMENT_CROSS_C_COMPILER, cross_compile & RADULA_CROSS_C_COMPILER)
    putEnv(RADULA_ENVIRONMENT_CROSS_C_COMPILER_LINKER, RADULA_CROSS_C_CXX_COMPILER_LINKER)
    putEnv(RADULA_ENVIRONMENT_CROSS_C_PREPROCESSOR, cross_compile & RADULA_CROSS_C_COMPILER & ' ' & RADULA_CROSS_C_CXX_PREPROCESSOR)
    putEnv(RADULA_ENVIRONMENT_CROSS_COMPILE, cross_compile)
    putEnv(RADULA_ENVIRONMENT_CROSS_CXX_COMPILER, cross_compile & RADULA_CROSS_CXX_COMPILER)
    putEnv(RADULA_ENVIRONMENT_CROSS_CXX_COMPILER_LINKER, RADULA_CROSS_C_CXX_COMPILER_LINKER)
    putEnv(RADULA_ENVIRONMENT_CROSS_CXX_PREPROCESSOR, cross_compile & RADULA_CROSS_CXX_COMPILER & ' ' & RADULA_CROSS_C_CXX_PREPROCESSOR)
    putEnv(RADULA_ENVIRONMENT_CROSS_HOST_C_COMPILER, RADULA_CROSS_C_COMPILER)
    putEnv(RADULA_ENVIRONMENT_CROSS_HOST_CXX_COMPILER, RADULA_CROSS_CXX_COMPILER)
    putEnv(RADULA_ENVIRONMENT_CROSS_LINKER, cross_compile & RADULA_CROSS_LINKER)
    putEnv(RADULA_ENVIRONMENT_CROSS_NAMES, cross_compile & RADULA_CROSS_NAMES)
    putEnv(RADULA_ENVIRONMENT_CROSS_OBJECT_COPY, cross_compile & RADULA_CROSS_OBJECT_COPY)
    putEnv(RADULA_ENVIRONMENT_CROSS_OBJECT_DUMP, cross_compile & RADULA_CROSS_OBJECT_DUMP)
    putEnv(RADULA_ENVIRONMENT_CROSS_RANDOM_ACCESS_LIBRARY, cross_compile & RADULA_CROSS_RANDOM_ACCESS_LIBRARY)
    putEnv(RADULA_ENVIRONMENT_CROSS_READ_ELF, cross_compile & RADULA_CROSS_READ_ELF)
    putEnv(RADULA_ENVIRONMENT_CROSS_SIZE, cross_compile & RADULA_CROSS_SIZE)
    putEnv(RADULA_ENVIRONMENT_CROSS_STRINGS, cross_compile & RADULA_CROSS_STRINGS)
    putEnv(RADULA_ENVIRONMENT_CROSS_STRIP, cross_compile & RADULA_CROSS_STRIP)

proc radula_behave_bootstrap_cross_img*() =
    # Default to `x86-64-v3`
    let img = getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS) / &"{RADULA_DIRECTORY_GLAUCUS}-{RADULA_CERAS_S6}-{RADULA_GENOME_X86_64_V3_IMG}-{now().format(\"ddMMYYYY\")}.img"

    # Create a new IMG image file
    discard execCmd(&"{RADULA_TOOTH_QEMU_IMG} create -f raw {img} {RADULA_FILE_GLAUCUS_IMG_SIZE} {RADULA_TOOTH_SHELL_REDIRECTION}")

    # Write mbr.bin (from SYSLINUX) to the first 440 bytes of the IMG image file
    discard execCmd(&"{RADULA_TOOTH_DD} if={RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS / RADULA_FILE_SYSLINUX_MBR_BIN} of={img} conv=notrunc bs=440 count=1 {RADULA_TOOTH_SHELL_REDIRECTION}")

    # Partition the IMG image file
    discard execCmd(&"{RADULA_TOOTH_PARTED} {RADULA_TOOTH_PARTED_FLAGS} {img} mklabel msdos")
    discard execCmd(&"{RADULA_TOOTH_PARTED} {RADULA_TOOTH_PARTED_FLAGS} -a none {img} mkpart primary ext4 0 {RADULA_FILE_GLAUCUS_IMG_SIZE}")
    discard execCmd(&"{RADULA_TOOTH_PARTED} {RADULA_TOOTH_PARTED_FLAGS} -a none {img} set 1 boot on")

    discard execCmd(&"{RADULA_TOOTH_MODPROBE} loop")

    # Detach all used loop devices
    discard execCmd(&"{RADULA_TOOTH_LOSETUP} -D")

    # Find the first unused loop device
    let
        device = execCmdEx(&"{RADULA_TOOTH_LOSETUP} -f")[0].strip()
        partition = device & "p1"

    # Associate the first unused loop device with the IMG image file
    discard execCmd(&"{RADULA_TOOTH_LOSETUP} {device} {img}")

    # Notify the kernel about the new partition on the IMG image file
    discard execCmd(&"{RADULA_TOOTH_PARTX} -a {device}")

    # Create an `ext4` partition in the partition
    discard execCmd(&"{RADULA_TOOTH_MKE2FS} {RADULA_TOOTH_MKE2FS_FLAGS} ext4 {partition}")

    let mount = RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_PATH_MNT / RADULA_DIRECTORY_GLAUCUS

    createDir(mount)

    discard execCmd(&"{RADULA_TOOTH_MOUNT} {partition} {mount}")

    # Remove `/lost+found` directory
    removeDir(mount / RADULA_PATH_LOST_FOUND)

    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS) & RADULA_PATH_PKG_CONFIG_SYSROOT_DIR, mount, RADULA_TOOTH_RSYNC_IMG_FLAGS)

    # Install `extlinux` as the default bootloader

    let path = mount / RADULA_PATH_BOOT / RADULA_TOOTH_EXTLINUX

    createDir(path)

    discard radula_behave_rsync(RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS / RADULA_FILE_SYSLINUX_EXTLINUX_CONF, path, RADULA_TOOTH_RSYNC_IMG_FLAGS)

    discard execCmd(&"{RADULA_TOOTH_EXTLINUX} {RADULA_TOOTH_EXTLINUX_FLAGS} {path}")

    # Change ownerships
    discard execCmd(&"{RADULA_TOOTH_CHOWN} {RADULA_TOOTH_CHMOD_CHOWN_FLAGS} 0:0 mount")
    discard execCmd(&"{RADULA_TOOTH_CHOWN} {RADULA_TOOTH_CHMOD_CHOWN_FLAGS} 20:20 {mount / RADULA_PATH_ETC / RADULA_PATH_UTMPS}")

    # Clean up
    discard execCmd(&"{RADULA_TOOTH_UMOUNT} {RADULA_TOOTH_UMOUNT_FLAGS} {mount} {RADULA_TOOTH_SHELL_REDIRECTION}")
    discard execCmd(&"{RADULA_TOOTH_PARTX} -d {partition} {RADULA_TOOTH_SHELL_REDIRECTION}")
    discard execCmd(&"{RADULA_TOOTH_LOSETUP} -d {device} {RADULA_TOOTH_SHELL_REDIRECTION}")

    # Backup the new IMG image file
    discard radula_behave_rsync(img, getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))

proc radula_behave_bootstrap_cross_prepare*() =
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS) / RADULA_DIRECTORY_CROSS, getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS))
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS) / RADULA_DIRECTORY_TOOLCHAIN, getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS))

    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS))
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS))

    # Create the `src` directory if it doesn't exist, but don't remove it if it does exist!
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_SOURCES))

    # Create the `log` directory if it doesn't exist, but don't remove it if it does exist!
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS))

    removeFile(getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG))

proc radula_behave_bootstrap_distclean*() =
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES))

    radula_behave_bootstrap_clean()

    # Only remove `RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY` completely after
    # `RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN_TEMPORARY_BUILDS` and
    # `RADULA_ENVIRONMENT_DIRECTORY_CROSS_TEMPORARY_BUILDS` are removed
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY))

proc radula_behave_bootstrap_environment*() =
    let path = parentDir(getCurrentDir())

    putEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS, path)

    putEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS, path / RADULA_DIRECTORY_BACKUPS)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA, path / RADULA_DIRECTORY_CERATA)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS, path / RADULA_DIRECTORY_CROSS)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS, path / RADULA_DIRECTORY_LOGS)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES, path / RADULA_DIRECTORY_SOURCES)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY, path / RADULA_DIRECTORY_TEMPORARY)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN, path / RADULA_DIRECTORY_TOOLCHAIN)

    putEnv(RADULA_ENVIRONMENT_PATH, getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN) / RADULA_PATH_USR / RADULA_PATH_BIN & ':' & getEnv(RADULA_ENVIRONMENT_PATH))

proc radula_behave_bootstrap_initialize*() =
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS))
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES))
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY))

proc radula_behave_bootstrap_toolchain_backup*() =
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS), getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN), getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))

    # Backup toolchain log file
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG), getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))

proc radula_behave_bootstrap_toolchain_ccache*() =
    putEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY, getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN) / RADULA_CERAS_CCACHE)
    putEnv(RADULA_ENVIRONMENT_PATH, RADULA_PATH_CCACHE & ':' & getEnv(RADULA_ENVIRONMENT_PATH))

    createDir(getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY))

proc radula_behave_bootstrap_toolchain_envenomate*() =
    radula_behave_envenomate([
        RADULA_CERAS_MUSL_HEADERS,
        RADULA_CERAS_BINUTILS,
        RADULA_CERAS_GCC,
        RADULA_CERAS_MUSL,
        RADULA_CERAS_LIBGCC,
        RADULA_CERAS_LIBSTDCXX_V3,
        RADULA_CERAS_LIBGOMP,
        RADULA_CERAS_CCACHE,
        RADULA_CERAS_MOLD
    ], RADULA_DIRECTORY_TOOLCHAIN, false)

proc radula_behave_bootstrap_toolchain_environment_directories*() =
    let path = getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY) / RADULA_DIRECTORY_TOOLCHAIN

    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN, path)

    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_BUILDS, path / RADULA_DIRECTORY_BUILDS)
    putEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_SOURCES, path / RADULA_DIRECTORY_SOURCES)

    # toolchain log file
    putEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG, getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS) / RADULA_DIRECTORY_TOOLCHAIN & CurDir & RADULA_DIRECTORY_LOGS)

proc radula_behave_bootstrap_toolchain_prepare*() =
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS))

    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN))

    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN))
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_BUILDS))
    # Create the `src` directory if it doesn't exist, but don't remove it if it does exist!
    createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_SOURCES))

proc radula_behave_bootstrap_toolchain_release*() =
    let path = RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_DIRECTORY_TOOLCHAIN

    removeDir(path)
    createDir(path)

    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS) / RADULA_DIRECTORY_CROSS, path)
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS) / RADULA_DIRECTORY_TOOLCHAIN, path)

    # Remove all `lib64` directories because glaucus is a pure 64-bit system
    removeDir(path / RADULA_DIRECTORY_CROSS / RADULA_PATH_LIB64)
    removeDir(path / RADULA_DIRECTORY_CROSS / RADULA_PATH_USR / RADULA_PATH_LIB64)
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR / RADULA_PATH_LIB64)

    # Remove libtool archive (.la) files
    for file in walkDirRec(path):
        if file.endsWith(".la"):
            removeFile(file)

    # Remove toolchain documentation
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR / RADULA_PATH_SHARE / RADULA_PATH_DOC)
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR / RADULA_PATH_SHARE / RADULA_PATH_INFO)
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR / RADULA_PATH_SHARE / RADULA_PATH_MAN)

    let status = radula_behave_create_archive_zstd(getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS) / &"{RADULA_DIRECTORY_TOOLCHAIN}-{now().format(\"ddMMYYYY\")}.tar.zst", path)

    if status == 0:
        removeDir(path)
