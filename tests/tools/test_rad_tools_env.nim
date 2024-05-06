# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[constants, tools]

rad_tools_env()

echo "AWK                 :: ", getEnv($AWK)
echo "BISON               :: ", getEnv($BISON)
echo "FLEX                :: ", getEnv($FLEX)
echo "LEX                 :: ", getEnv($LEX)
echo "MAKE                :: ", getEnv($RAD_ENV.MAKE)
echo "MAKEFLAGS           :: ", getEnv($MAKEFLAGS)
echo "PKG_CONFIG          :: ", getEnv($PKG_CONFIG)
echo "RAD_RSYNC_FLAGS     :: ", getEnv($RAD_RSYNC_FLAGS)
echo "YACC                :: ", getEnv($YACC)

doAssert getEnv($AWK) == "mawk"
doAssert getEnv($BISON) == "byacc"
doAssert getEnv($FLEX) == "flex"
doAssert getEnv($LEX) == "flex"
doAssert getEnv($RAD_ENV.MAKE) == "make"
doAssert getEnv($MAKEFLAGS) == "-j4 -O"
doAssert getEnv($PKG_CONFIG) == "pkgconf"
doAssert getEnv($RAD_RSYNC_FLAGS) == "-vaHAXSx"
doAssert getEnv($YACC) == "byacc"
