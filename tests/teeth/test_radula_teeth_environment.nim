# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os

import ../../src/constants
import ../../src/teeth

radula_teeth_environment()

echo "AUTORECONF  :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF)
echo "AWK         :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_AWK)
echo "BISON       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_BISON)
echo "FLEX        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX)
echo "LEX         :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_LEX)
echo "MAKE        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE)
echo "MAKEFLAGS   :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS)
echo "PATCH       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_PATCH)
echo "PKG_CONFIG  :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG)
echo "RSYNC       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC)
echo "YACC        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_YACC)

doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF) == "autoreconf -vfis"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_AWK) == "mawk"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_BISON) == "byacc"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX) == "flex"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_LEX) == "flex"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE) == "make"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS) == "-j4 -O"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_PATCH) == "patch --no-backup-if-mismatch --verbose"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG) == "pkgconf"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC) == "rsync -vaHAXSx"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_YACC) == "byacc"
