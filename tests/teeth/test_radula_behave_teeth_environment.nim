# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os

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

assert getEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF) == "autoreconf -vfis"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_AWK) == "mawk"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_BISON) == "byacc"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_CHMOD) == "chmod -Rv"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_CHOWN) == "chown -Rv"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX) == "flex"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_GAWK) == "mawk"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_LEX) == "flex"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_LN) == "ln -fnsv"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE) == "make"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS) == "-j4 -O"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR) == "/usr/bin/install -dv"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR_P) == "/usr/bin/install -dv"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_MV) == "mv -v"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_PATCH) == "patch --verbose"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG) == "pkgconf"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_RM) == "rm -frv"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC) == "rsync -vaHAXSx"
assert getEnv(RADULA_ENVIRONMENT_TOOTH_YACC) == "byacc"
