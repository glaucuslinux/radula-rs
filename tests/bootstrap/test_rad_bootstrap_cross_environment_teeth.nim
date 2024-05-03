# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants, genome]

rad_bootstrap_environment()

rad_genome_environment()

rad_bootstrap_cross_environment_teeth()

echo "CROSS_COMPILE  :: ", getEnv(RAD_ENV_CROSS_COMPILE)

echo ""

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

doAssert getEnv(RAD_ENV_CROSS_COMPILE).endsWith("-")

doAssert getEnv(RAD_ENV_TOOTH_AR).endsWith("gcc-ar")
doAssert getEnv(RAD_ENV_TOOTH_AS).endsWith("as")
doAssert getEnv(RAD_ENV_TOOTH_CC).endsWith("gcc")
doAssert getEnv(RAD_ENV_TOOTH_CPP).endsWith("gcc -E")
doAssert getEnv(RAD_ENV_TOOTH_CXX).endsWith("g++")
doAssert getEnv(RAD_ENV_TOOTH_CXXCPP).endsWith("g++ -E")
doAssert getEnv(RAD_ENV_TOOTH_HOSTCC) == "gcc"
doAssert getEnv(RAD_ENV_TOOTH_NM).endsWith("gcc-nm")
doAssert getEnv(RAD_ENV_TOOTH_OBJCOPY).endsWith("objcopy")
doAssert getEnv(RAD_ENV_TOOTH_OBJDUMP).endsWith("objdump")
doAssert getEnv(RAD_ENV_TOOTH_RANLIB).endsWith("gcc-ranlib")
doAssert getEnv(RAD_ENV_TOOTH_READELF).endsWith("readelf")
doAssert getEnv(RAD_ENV_TOOTH_SIZE).endsWith("size")
doAssert getEnv(RAD_ENV_TOOTH_STRIP).endsWith("strip")
