# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import strutils

import ../../src/architecture
import ../../src/bootstrap
import ../../src/constants
import ../../src/cross

radula_behave_bootstrap_environment()

radula_behave_architecture_environment(RADULA_ARCHITECTURE_X86_64_V3)

radula_behave_bootstrap_cross_environment_teeth()

echo "AR             :: ", getEnv(RADULA_ENVIRONMENT_CROSS_ARCHIVER)
echo "AS             :: ", getEnv(RADULA_ENVIRONMENT_CROSS_ASSEMBLER)
echo "BUILD_CC       :: ", getEnv(RADULA_ENVIRONMENT_CROSS_BUILD_C_COMPILER)
echo "CROSS_COMPILE  :: ", getEnv(RADULA_ENVIRONMENT_CROSS_COMPILE)
echo "CC             :: ", getEnv(RADULA_ENVIRONMENT_CROSS_C_COMPILER)
echo "CC_LD          :: ", getEnv(RADULA_ENVIRONMENT_CROSS_C_COMPILER_LINKER)
echo "CPP            :: ", getEnv(RADULA_ENVIRONMENT_CROSS_C_PREPROCESSOR)
echo "CXX            :: ", getEnv(RADULA_ENVIRONMENT_CROSS_CXX_COMPILER)
echo "CXX_LD         :: ", getEnv(RADULA_ENVIRONMENT_CROSS_CXX_COMPILER_LINKER)
echo "HOSTCC         :: ", getEnv(RADULA_ENVIRONMENT_CROSS_HOST_C_COMPILER)
echo "HOSTCXX        :: ", getEnv(RADULA_ENVIRONMENT_CROSS_HOST_CXX_COMPILER)
echo "LD             :: ", getEnv(RADULA_ENVIRONMENT_CROSS_LINKER)
echo "NM             :: ", getEnv(RADULA_ENVIRONMENT_CROSS_NAMES)
echo "OBJCOPY        :: ", getEnv(RADULA_ENVIRONMENT_CROSS_OBJECT_COPY)
echo "OBJDUMP        :: ", getEnv(RADULA_ENVIRONMENT_CROSS_OBJECT_DUMP)
echo "RANLIB         :: ", getEnv(RADULA_ENVIRONMENT_CROSS_RANDOM_ACCESS_LIBRARY)
echo "READELF        :: ", getEnv(RADULA_ENVIRONMENT_CROSS_READ_ELF)
echo "SIZE           :: ", getEnv(RADULA_ENVIRONMENT_CROSS_SIZE)
echo "STRINGS        :: ", getEnv(RADULA_ENVIRONMENT_CROSS_STRINGS)
echo "STRIP          :: ", getEnv(RADULA_ENVIRONMENT_CROSS_STRIP)

doAssert getEnv(RADULA_ENVIRONMENT_CROSS_ARCHIVER).endsWith("gcc-ar")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_ASSEMBLER).endsWith("as")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_BUILD_C_COMPILER) == "gcc"
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_COMPILE).endsWith("-")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_C_COMPILER).endsWith("gcc")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_C_COMPILER_LINKER) == "bfd"
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_C_PREPROCESSOR).endsWith("gcc -E")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_CXX_COMPILER).endsWith("g++")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_CXX_COMPILER_LINKER) == "bfd"
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_HOST_C_COMPILER) == "gcc"
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_HOST_CXX_COMPILER) == "g++"
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_LINKER).endsWith("ld.bfd")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_NAMES).endsWith("gcc-nm")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_OBJECT_COPY).endsWith("objcopy")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_OBJECT_DUMP).endsWith("objdump")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_RANDOM_ACCESS_LIBRARY).endsWith("gcc-ranlib")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_READ_ELF).endsWith("readelf")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_SIZE).endsWith("size")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_STRINGS).endsWith("strings")
doAssert getEnv(RADULA_ENVIRONMENT_CROSS_STRIP).endsWith("strip")
