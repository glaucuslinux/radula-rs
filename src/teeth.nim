# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    osproc,
    strformat
]

import constants

#
# Compress Functions
#

proc radula_behave_compress*(archive, directory: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} --use-compress-program '{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_COMPRESS_FLAGS}' {RADULA_TOOTH_TAR_CREATE_FLAGS} {archive} -C {directory} .")

proc radula_behave_decompress*(archive, directory: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} --use-compress-program '{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_DECOMPRESS_FLAGS}' {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {archive} -C {directory}")

#
# rsync Function
#

proc radula_behave_rsync*(source, destination: string): (string, int) =
    execCmdEx(&"{RADULA_CERAS_RSYNC} {RADULA_TOOTH_RSYNC_FLAGS} {source} {destination} --delete")

#
# Teeth Functions
#

proc radula_behave_teeth_environment*() =
    putEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF, RADULA_TOOTH_AUTORECONF & " " & RADULA_TOOTH_AUTORECONF_FLAGS)
    # Use `mawk` as the default AWK implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_AWK, RADULA_CERAS_MAWK)
    # Use `byacc` as the default YACC implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_BISON, RADULA_CERAS_BYACC)
    putEnv(RADULA_ENVIRONMENT_TOOTH_CHMOD, RADULA_TOOTH_CHMOD & " " & RADULA_TOOTH_CHMOD_CHOWN_FLAGS)
    putEnv(RADULA_ENVIRONMENT_TOOTH_CHOWN, RADULA_TOOTH_CHOWN & " " & RADULA_TOOTH_CHMOD_CHOWN_FLAGS)
    # Use `flex` as the default LEX implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_FLEX, RADULA_CERAS_FLEX)
    # Use `mawk` as the default AWK implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_GAWK, RADULA_CERAS_MAWK)
    # Use `flex` as the default LEX implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_LEX, RADULA_CERAS_FLEX)
    putEnv(RADULA_ENVIRONMENT_TOOTH_LN, RADULA_TOOTH_LN & " " & RADULA_TOOTH_LN_FLAGS)
    # `make` and its flags
    putEnv(RADULA_ENVIRONMENT_TOOTH_MAKE, RADULA_CERAS_MAKE)
    putEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS, RADULA_TOOTH_MAKEFLAGS)
    putEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR, RADULA_TOOTH_MKDIR & " " & RADULA_TOOTH_MKDIR_FLAGS)
    putEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR_P, RADULA_TOOTH_MKDIR & " " & RADULA_TOOTH_MKDIR_FLAGS)
    putEnv(RADULA_ENVIRONMENT_TOOTH_MV, RADULA_TOOTH_MV & " " & RADULA_TOOTH_MV_FLAGS)
    putEnv(RADULA_ENVIRONMENT_TOOTH_PATCH, RADULA_CERAS_PATCH & " " & RADULA_TOOTH_PATCH_FLAGS)
    # Use `pkgconf` as the default PKG_CONFIG implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG, RADULA_CERAS_PKGCONF)
    putEnv(RADULA_ENVIRONMENT_TOOTH_RM, RADULA_TOOTH_RM & " " & RADULA_TOOTH_RM_FLAGS)
    putEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC, RADULA_CERAS_RSYNC & " " & RADULA_TOOTH_RSYNC_FLAGS)
    # Use `byacc` as the default YACC implementation
    putEnv(RADULA_ENVIRONMENT_TOOTH_YACC, RADULA_CERAS_BYACC)
