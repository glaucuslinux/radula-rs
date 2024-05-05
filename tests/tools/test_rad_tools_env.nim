# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[constants, tools]

rad_tools_env()

echo "AWK                 :: ", getEnv(RAD_ENV_TOOL_AWK)
echo "BISON               :: ", getEnv(RAD_ENV_TOOL_BISON)
echo "FLEX                :: ", getEnv(RAD_ENV_TOOL_FLEX)
echo "LEX                 :: ", getEnv(RAD_ENV_TOOL_LEX)
echo "MAKE                :: ", getEnv(RAD_ENV_TOOL_MAKE)
echo "MAKEFLAGS           :: ", getEnv(RAD_ENV_TOOL_MAKEFLAGS)
echo "PKG_CONFIG          :: ", getEnv(RAD_ENV_TOOL_PKG_CONFIG)
echo "RAD_RSYNC_FLAGS     :: ", getEnv(RAD_ENV_TOOL_RAD_RSYNC_FLAGS)
echo "YACC                :: ", getEnv(RAD_ENV_TOOL_YACC)

doAssert getEnv(RAD_ENV_TOOL_AWK) == "mawk"
doAssert getEnv(RAD_ENV_TOOL_BISON) == "byacc"
doAssert getEnv(RAD_ENV_TOOL_FLEX) == "flex"
doAssert getEnv(RAD_ENV_TOOL_LEX) == "flex"
doAssert getEnv(RAD_ENV_TOOL_MAKE) == "make"
doAssert getEnv(RAD_ENV_TOOL_MAKEFLAGS) == "-j4 -O"
doAssert getEnv(RAD_ENV_TOOL_PKG_CONFIG) == "pkgconf"
doAssert getEnv(RAD_ENV_TOOL_RAD_RSYNC_FLAGS) == "-vaHAXSx"
doAssert getEnv(RAD_ENV_TOOL_YACC) == "byacc"
