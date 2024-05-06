# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[arch, bootstrap, constants]

rad_arch_env()
rad_bootstrap_native_env_tools()

echo "AR             :: ", getEnv($AR)
echo "AS             :: ", getEnv($RAD_ENV.AS)
echo "CC             :: ", getEnv($CC)
echo "CPP            :: ", getEnv($RAD_ENV.CPP)
echo "CXX            :: ", getEnv($CXX)
echo "CXXCPP         :: ", getEnv($CXXCPP)
echo "HOSTCC         :: ", getEnv($HOSTCC)
echo "NM             :: ", getEnv($NM)
echo "OBJCOPY        :: ", getEnv($OBJCOPY)
echo "OBJDUMP        :: ", getEnv($OBJDUMP)
echo "RANLIB         :: ", getEnv($RANLIB)
echo "READELF        :: ", getEnv($READELF)
echo "SIZE           :: ", getEnv($SIZE)
echo "STRIP          :: ", getEnv($STRIP)

doAssert getEnv($AR) == "gcc-ar"
doAssert getEnv($RAD_ENV.AS) == "as"
doAssert getEnv($CC) == "gcc"
doAssert getEnv($RAD_ENV.CPP) == "gcc -E"
doAssert getEnv($CXX) == "g++"
doAssert getEnv($CXXCPP) == "g++ -E"
doAssert getEnv($HOSTCC) == "gcc"
doAssert getEnv($NM) == "gcc-nm"
doAssert getEnv($OBJCOPY) == "objcopy"
doAssert getEnv($OBJDUMP) == "objdump"
doAssert getEnv($RANLIB) == "gcc-ranlib"
doAssert getEnv($READELF) == "readelf"
doAssert getEnv($SIZE) == "size"
doAssert getEnv($STRIP) == "strip"
