# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[bootstrap, constants, genome]

rad_genome_environment()

rad_bootstrap_system_environment_teeth()

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

doAssert getEnv(RAD_ENVIRONMENT_TOOTH_ARCHIVER) == "gcc-ar"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_ASSEMBLER) == "as"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_C_COMPILER) == "gcc"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_C_PREPROCESSOR) == "gcc -E"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_CXX_COMPILER) == "g++"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_CXX_PREPROCESSOR) == "g++ -E"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_HOST_C_COMPILER) == "gcc"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_NAMES) == "gcc-nm"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_OBJECT_COPY) == "objcopy"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_OBJECT_DUMP) == "objdump"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_RANDOM_ACCESS_LIBRARY) == "gcc-ranlib"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_READ_ELF) == "readelf"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_SIZE) == "size"
doAssert getEnv(RAD_ENVIRONMENT_TOOTH_STRIP) == "strip"
