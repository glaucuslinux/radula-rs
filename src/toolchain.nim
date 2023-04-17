# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    strutils,
    times
]

import
    constants,
    envenomate,
    teeth

#
# Toolchain Functions
#

proc radula_behave_bootstrap_toolchain_backup*() =
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS),
        getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN),
        getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))

    # Backup toolchain log file
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG),
        getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))

proc radula_behave_bootstrap_toolchain_ccache*() =
    putEnv(RADULA_ENVIRONMENT_CCACHE_CONFIGURATION,
        RADULA_PATH_RADULA_CLUSTERS / RADULA_DIRECTORY_GLAUCUS /
        RADULA_CERAS_CCACHE / RADULA_FILE_CCACHE_CONFIGURATION)
    putEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY, getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN) / RADULA_CERAS_CCACHE)
    putEnv(RADULA_ENVIRONMENT_PATH, RADULA_PATH_CCACHE & ':' & getEnv(RADULA_ENVIRONMENT_PATH))
    createDir(getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY))


proc radula_behave_bootstrap_toolchain_envenomate*() =
    radula_behave_envenomate(@[
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
    putEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG, getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_LOGS) / RADULA_DIRECTORY_TOOLCHAIN &
        CurDir & RADULA_DIRECTORY_LOGS)

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

    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS) /
        RADULA_DIRECTORY_CROSS, path)
    discard radula_behave_rsync(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS) /
        RADULA_DIRECTORY_TOOLCHAIN, path)

    # Remove all `lib64` directories because glaucus is a pure 64-bit system
    removeDir(path / RADULA_DIRECTORY_CROSS / RADULA_PATH_LIB64)
    removeDir(path / RADULA_DIRECTORY_CROSS / RADULA_PATH_USR / RADULA_PATH_LIB64)
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR / RADULA_PATH_LIB64)

    # Remove libtool archive (.la) files
    for file in walkDirRec(path):
        if file.endsWith(".la"):
            removeFile(file)

    # Remove toolchain documentation
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR /
        RADULA_PATH_SHARE / RADULA_PATH_DOC)
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR /
        RADULA_PATH_SHARE / RADULA_PATH_INFO)
    removeDir(path / RADULA_DIRECTORY_TOOLCHAIN / RADULA_PATH_USR /
        RADULA_PATH_SHARE / RADULA_PATH_MAN)

    discard radula_behave_compress(getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS) / RADULA_DIRECTORY_TOOLCHAIN &
        "-" & now().format("ddMMYYYY") & ".tar.zst", path)
