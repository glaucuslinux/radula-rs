# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[constants, teeth]

rad_teeth_environment()

echo "AWK                 :: ", getEnv(RAD_ENVIRONMENT_TOOTH_AWK)
echo "BISON               :: ", getEnv(RAD_ENVIRONMENT_TOOTH_BISON)
echo "FLEX                :: ", getEnv(RAD_ENVIRONMENT_TOOTH_FLEX)
echo "LEX                 :: ", getEnv(RAD_ENVIRONMENT_TOOTH_LEX)
echo "MAKE                :: ", getEnv(RAD_ENVIRONMENT_TOOTH_MAKE)
echo "MAKEFLAGS           :: ", getEnv(RAD_ENVIRONMENT_TOOTH_MAKEFLAGS)
echo "PKG_CONFIG          :: ", getEnv(RAD_ENVIRONMENT_TOOTH_PKG_CONFIG)
echo "RAD_RSYNC_FLAGS     :: ", getEnv(RAD_ENVIRONMENT_TOOTH_RAD_RSYNC_FLAGS)
echo "YACC                :: ", getEnv(RAD_ENVIRONMENT_TOOTH_YACC)

doAssert getEnv(RAD_ENVIRONMENT_TOOTH_AWK) == "mawk"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_BISON) == "byacc"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_FLEX) == "flex"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_LEX) == "flex"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_MAKE) == "make"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_MAKEFLAGS) == "-j4 -O"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_PKG_CONFIG) == "pkgconf"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_RAD_RSYNC_FLAGS) == "-vaHAXSx"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_YACC) == "byacc"
