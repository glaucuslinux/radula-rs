# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    strformat,
    terminal,
    times
]

import constants

#
# Clean Functions
#

proc radula_behave_bootstrap_clean*() =
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS))

    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS))

    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS))

    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_BUILDS))

    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN))

proc radula_behave_bootstrap_distclean*() =
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS))

    removeFile(getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS) / RADULA_FILE_GLAUCUS_IMG)

    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES))

    radula_behave_bootstrap_clean()

    # Only remove `RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY` completely after
    # `RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN_TEMPORARY_BUILDS` and
    # `RADULA_ENVIRONMENT_DIRECTORY_CROSS_TEMPORARY_BUILDS` are removed
    removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY))

proc radula_behave_abort*() {.noconv.} =
    echo ""

    styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {\"interrupt signal received\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    quit(1)
