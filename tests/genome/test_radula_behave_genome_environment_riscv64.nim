# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  strutils
]

import
  ../../src/constants,
  ../../src/genome

radula_behave_genome_environment(RADULA_GENOME_RISCV64)

echo "BLD     :: ", getEnv(RADULA_ENVIRONMENT_TUPLE_BUILD)

echo ""

echo "ARCH    :: ", getEnv(RADULA_ENVIRONMENT_GENOME)
echo "CARCH   :: ", getEnv(RADULA_ENVIRONMENT_GENOME_CERATA)
echo "FARCH   :: ", getEnv(RADULA_ENVIRONMENT_GENOME_FLAGS)
echo "GCARCH  :: ", getEnv(RADULA_ENVIRONMENT_GENOME_GCC_CONFIGURATION)
echo "LARCH   :: ", getEnv(RADULA_ENVIRONMENT_GENOME_LINUX)
echo "LCARCH  :: ", getEnv(RADULA_ENVIRONMENT_GENOME_LINUX_CONFIGURATION)
echo "LIARCH  :: ", getEnv(RADULA_ENVIRONMENT_GENOME_LINUX_IMAGE)
echo "MARCH   :: ", getEnv(RADULA_ENVIRONMENT_GENOME_MUSL)
echo "MLARCH  :: ", getEnv(RADULA_ENVIRONMENT_GENOME_MUSL_LINKER)
echo "TGT     :: ", getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET)
echo "UARCH   :: ", getEnv(RADULA_ENVIRONMENT_GENOME_UCONTEXT)

doAssert getEnv(RADULA_ENVIRONMENT_TUPLE_BUILD) == radula_behave_genome_tuple()[0].strip()

doAssert getEnv(RADULA_ENVIRONMENT_GENOME) == "riscv64"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_CERATA) == "--with-gcc-arch=rv64gc"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_FLAGS) == "-mabi=lp64d -march=rv64gc -mcpu=sifive-u74 -mtune=sifive-7-series -mcmodel=medany"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_GCC_CONFIGURATION) == "--with-cpu=sifive-u74 --with-arch=rv64gc --with-tune=sifive-7-series --with-abi=lp64d"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_LINUX) == "riscv"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_LINUX_CONFIGURATION) == ""
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_LINUX_IMAGE) == "arch/riscv/boot/Image"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_MUSL) == "riscv64"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_MUSL_LINKER) == "riscv64"
doAssert getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET) == "riscv64-linux-musl"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_UCONTEXT) == "riscv64"
