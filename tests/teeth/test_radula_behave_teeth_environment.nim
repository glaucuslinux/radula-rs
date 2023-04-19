# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os

import ../../src/constants
import ../../src/teeth

radula_behave_teeth_environment()

echo "AUTORECONF  :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF)
echo "AWK         :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_AWK)
echo "BISON       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_BISON)
echo "CHMOD       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_CHMOD)
echo "CHOWN       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_CHOWN)
echo "FLEX        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX)
echo "GAWK        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_GAWK)
echo "LEX         :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_LEX)
echo "LN          :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_LN)
echo "MAKE        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE)
echo "MAKEFLAGS   :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS)
echo "MKDIR       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR)
echo "MKDIR_P     :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR_P)
echo "MV          :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MV)
echo "PATCH       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_PATCH)
echo "PKG_CONFIG  :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG)
echo "RM          :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_RM)
echo "RSYNC       :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC)
echo "YACC        :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_YACC)

doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF) == "autoreconf -vfis"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_AWK) == "mawk"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_BISON) == "byacc"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_CHMOD) == "chmod -Rv"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_CHOWN) == "chown -Rv"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX) == "flex"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_GAWK) == "mawk"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_LEX) == "flex"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_LN) == "ln -fnsv"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE) == "make"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS) == "-j4 -O"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR) == "/usr/bin/install -dv"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR_P) == "/usr/bin/install -dv"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MV) == "mv -v"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_PATCH) == "patch --verbose"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG) == "pkgconf"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_RM) == "rm -frv"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC) == "rsync -vaHAXSx"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_YACC) == "byacc"
