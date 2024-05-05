# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[arch, bootstrap, constants]

rad_arch_env()

rad_bootstrap_native_env_tools()

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

doAssert getEnv(RAD_ENV_TOOL_AR) == "gcc-ar"
doAssert getEnv(RAD_ENV_TOOL_AS) == "as"
doAssert getEnv(RAD_ENV_TOOL_CC) == "gcc"
doAssert getEnv(RAD_ENV_TOOL_CPP) == "gcc -E"
doAssert getEnv(RAD_ENV_TOOL_CXX) == "g++"
doAssert getEnv(RAD_ENV_TOOL_CXXCPP) == "g++ -E"
doAssert getEnv(RAD_ENV_TOOL_HOSTCC) == "gcc"
doAssert getEnv(RAD_ENV_TOOL_NM) == "gcc-nm"
doAssert getEnv(RAD_ENV_TOOL_OBJCOPY) == "objcopy"
doAssert getEnv(RAD_ENV_TOOL_OBJDUMP) == "objdump"
doAssert getEnv(RAD_ENV_TOOL_RANLIB) == "gcc-ranlib"
doAssert getEnv(RAD_ENV_TOOL_READELF) == "readelf"
doAssert getEnv(RAD_ENV_TOOL_SIZE) == "size"
doAssert getEnv(RAD_ENV_TOOL_STRIP) == "strip"
