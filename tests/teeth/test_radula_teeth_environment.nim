# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[constants, teeth]

radula_teeth_environment()

echo "AWK                 :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_AWK)
echo "BISON               :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_BISON)
echo "FLEX                :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX)
echo "LEX                 :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_LEX)
echo "MAKE                :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE)
echo "MAKEFLAGS           :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS)
echo "PKG_CONFIG          :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG)
echo "RADULA_RSYNC_FLAGS  :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_RADULA_RSYNC_FLAGS)
echo "YACC                :: ", getEnv(RADULA_ENVIRONMENT_TOOTH_YACC)

doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_AWK) == "mawk"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_BISON) == "byacc"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_FLEX) == "flex"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_LEX) == "flex"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKE) == "make"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS) == "-j4 -O"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG) == "pkgconf"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_RADULA_RSYNC_FLAGS) == "-vaHAXSx"
doAssert getEnv(RADULA_ENVIRONMENT_TOOTH_YACC) == "byacc"
