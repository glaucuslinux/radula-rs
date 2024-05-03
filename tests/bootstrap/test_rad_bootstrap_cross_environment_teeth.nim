# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants, genome]

rad_bootstrap_environment()

rad_genome_environment()

rad_bootstrap_cross_environment_teeth()

echo "CROSS_COMPILE  :: ", getEnv(RAD_ENVIRONMENT_CROSS_COMPILE)

echo ""

echo "AR             :: ", getEnv(RAD_ENVIRONMENT_TOOTH_ARCHIVER)
echo "AS             :: ", getEnv(RAD_ENVIRONMENT_TOOTH_ASSEMBLER)
echo "CC             :: ", getEnv(RAD_ENVIRONMENT_TOOTH_C_COMPILER)
echo "CPP            :: ", getEnv(RAD_ENVIRONMENT_TOOTH_C_PREPROCESSOR)
echo "CXX            :: ", getEnv(RAD_ENVIRONMENT_TOOTH_CXX_COMPILER)
echo "CXXCPP         :: ", getEnv(RAD_ENVIRONMENT_TOOTH_CXX_PREPROCESSOR)
echo "HOSTCC         :: ", getEnv(RAD_ENVIRONMENT_TOOTH_HOST_C_COMPILER)
echo "NM             :: ", getEnv(RAD_ENVIRONMENT_TOOTH_NAMES)
echo "OBJCOPY        :: ", getEnv(RAD_ENVIRONMENT_TOOTH_OBJECT_COPY)
echo "OBJDUMP        :: ", getEnv(RAD_ENVIRONMENT_TOOTH_OBJECT_DUMP)
echo "RANLIB         :: ", getEnv(RAD_ENVIRONMENT_TOOTH_RANDOM_ACCESS_LIBRARY)
echo "READELF        :: ", getEnv(RAD_ENVIRONMENT_TOOTH_READ_ELF)
echo "SIZE           :: ", getEnv(RAD_ENVIRONMENT_TOOTH_SIZE)
echo "STRIP          :: ", getEnv(RAD_ENVIRONMENT_TOOTH_STRIP)

doAssert getEnv(RAD_ENVIRONMENT_CROSS_COMPILE).endsWith("-")

doAssert getEnv(RAD_ENVIRONMENT_TOOTH_ARCHIVER).endsWith("gcc-ar")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_ASSEMBLER).endsWith("as")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_C_COMPILER).endsWith("gcc")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_C_PREPROCESSOR).endsWith("gcc -E")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_CXX_COMPILER).endsWith("g++")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_CXX_PREPROCESSOR).endsWith("g++ -E")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_HOST_C_COMPILER) == "gcc"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_NAMES).endsWith("gcc-nm")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_OBJECT_COPY).endsWith("objcopy")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_OBJECT_DUMP).endsWith("objdump")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_RANDOM_ACCESS_LIBRARY).endsWith("gcc-ranlib")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_READ_ELF).endsWith("readelf")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_SIZE).endsWith("size")
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_STRIP).endsWith("strip")
