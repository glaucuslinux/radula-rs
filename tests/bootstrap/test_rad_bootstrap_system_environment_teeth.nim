# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[bootstrap, constants, genome]

rad_genome_env()

rad_bootstrap_system_env_teeth()

echo "AR             :: ", getEnv(RAD_ENV_TOOTH_AR)
echo "AS             :: ", getEnv(RAD_ENV_TOOTH_AS)
echo "CC             :: ", getEnv(RAD_ENV_TOOTH_CC)
echo "CPP            :: ", getEnv(RAD_ENV_TOOTH_CPP)
echo "CXX            :: ", getEnv(RAD_ENV_TOOTH_CXX)
echo "CXXCPP         :: ", getEnv(RAD_ENV_TOOTH_CXXCPP)
echo "HOSTCC         :: ", getEnv(RAD_ENV_TOOTH_HOSTCC)
echo "NM             :: ", getEnv(RAD_ENV_TOOTH_NM)
echo "OBJCOPY        :: ", getEnv(RAD_ENV_TOOTH_OBJCOPY)
echo "OBJDUMP        :: ", getEnv(RAD_ENV_TOOTH_OBJDUMP)
echo "RANLIB         :: ", getEnv(RAD_ENV_TOOTH_RANLIB)
echo "READELF        :: ", getEnv(RAD_ENV_TOOTH_READELF)
echo "SIZE           :: ", getEnv(RAD_ENV_TOOTH_SIZE)
echo "STRIP          :: ", getEnv(RAD_ENV_TOOTH_STRIP)

doAssert getEnv(RAD_ENV_TOOTH_AR) == "gcc-ar"
doAssert getEnv(RAD_ENV_TOOTH_AS) == "as"
doAssert getEnv(RAD_ENV_TOOTH_CC) == "gcc"
doAssert getEnv(RAD_ENV_TOOTH_CPP) == "gcc -E"
doAssert getEnv(RAD_ENV_TOOTH_CXX) == "g++"
doAssert getEnv(RAD_ENV_TOOTH_CXXCPP) == "g++ -E"
doAssert getEnv(RAD_ENV_TOOTH_HOSTCC) == "gcc"
doAssert getEnv(RAD_ENV_TOOTH_NM) == "gcc-nm"
doAssert getEnv(RAD_ENV_TOOTH_OBJCOPY) == "objcopy"
doAssert getEnv(RAD_ENV_TOOTH_OBJDUMP) == "objdump"
doAssert getEnv(RAD_ENV_TOOTH_RANLIB) == "gcc-ranlib"
doAssert getEnv(RAD_ENV_TOOTH_READELF) == "readelf"
doAssert getEnv(RAD_ENV_TOOTH_SIZE) == "size"
doAssert getEnv(RAD_ENV_TOOTH_STRIP) == "strip"
