# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[arch, bootstrap, constants]

rad_arch_env(RAD_STAGE_CROSS)
rad_bootstrap_env()
rad_bootstrap_cross_env_tools()

echo "CROSS_COMPILE  :: ", getEnv(RAD_ENV_CROSS_COMPILE)

echo ""

echo "AR             :: ", getEnv(RAD_ENV_TOOL_AR)
echo "AS             :: ", getEnv(RAD_ENV_TOOL_AS)
echo "CC             :: ", getEnv(RAD_ENV_TOOL_CC)
echo "CPP            :: ", getEnv(RAD_ENV_TOOL_CPP)
echo "CXX            :: ", getEnv(RAD_ENV_TOOL_CXX)
echo "CXXCPP         :: ", getEnv(RAD_ENV_TOOL_CXXCPP)
echo "HOSTCC         :: ", getEnv(RAD_ENV_TOOL_HOSTCC)
echo "NM             :: ", getEnv(RAD_ENV_TOOL_NM)
echo "OBJCOPY        :: ", getEnv(RAD_ENV_TOOL_OBJCOPY)
echo "OBJDUMP        :: ", getEnv(RAD_ENV_TOOL_OBJDUMP)
echo "RANLIB         :: ", getEnv(RAD_ENV_TOOL_RANLIB)
echo "READELF        :: ", getEnv(RAD_ENV_TOOL_READELF)
echo "SIZE           :: ", getEnv(RAD_ENV_TOOL_SIZE)
echo "STRIP          :: ", getEnv(RAD_ENV_TOOL_STRIP)

doAssert getEnv(RAD_ENV_CROSS_COMPILE).endsWith("-")

doAssert getEnv(RAD_ENV_TOOL_AR).endsWith("gcc-ar")
doAssert getEnv(RAD_ENV_TOOL_AS).endsWith("as")
doAssert getEnv(RAD_ENV_TOOL_CC).endsWith("gcc")
doAssert getEnv(RAD_ENV_TOOL_CPP).endsWith("gcc -E")
doAssert getEnv(RAD_ENV_TOOL_CXX).endsWith("g++")
doAssert getEnv(RAD_ENV_TOOL_CXXCPP).endsWith("g++ -E")
doAssert getEnv(RAD_ENV_TOOL_HOSTCC) == "gcc"
doAssert getEnv(RAD_ENV_TOOL_NM).endsWith("gcc-nm")
doAssert getEnv(RAD_ENV_TOOL_OBJCOPY).endsWith("objcopy")
doAssert getEnv(RAD_ENV_TOOL_OBJDUMP).endsWith("objdump")
doAssert getEnv(RAD_ENV_TOOL_RANLIB).endsWith("gcc-ranlib")
doAssert getEnv(RAD_ENV_TOOL_READELF).endsWith("readelf")
doAssert getEnv(RAD_ENV_TOOL_SIZE).endsWith("size")
doAssert getEnv(RAD_ENV_TOOL_STRIP).endsWith("strip")
