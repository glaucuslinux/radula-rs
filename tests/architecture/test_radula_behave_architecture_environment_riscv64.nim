# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os

import ../../src/architecture
import ../../src/constants

radula_behave_architecture_environment("riscv64")

echo "BLD     :: ", getEnv(RADULA_ENVIRONMENT_TUPLE_BUILD)

echo ""

echo "ARCH    :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE)
echo "CARCH   :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_CERATA)
echo "FARCH   :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_FLAGS)
echo "GCARCH  :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_GCC_CONFIGURATION)
echo "LARCH   :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX)
echo "LCARCH  :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_CONFIGURATION)
echo "LIARCH  :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_IMAGE)
echo "MARCH   :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL)
echo "MLARCH  :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL_LINKER)
echo "TGT     :: ", getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET)
echo "UARCH   :: ", getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_UCONTEXT)

assert getEnv(RADULA_ENVIRONMENT_TUPLE_BUILD) ==
    radula_behave_architecture_tuple()

assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE) == "riscv64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_CERATA) == "--with-gcc-arch=rv64gc"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_FLAGS) == "-mabi=lp64d -march=rv64gc -mcpu=sifive-u74 -mtune=sifive-7-series -mcmodel=medany"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_GCC_CONFIGURATION) == "--with-cpu=sifive-u74 --with-arch=rv64gc --with-tune=sifive-7-series --with-abi=lp64d"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX) == "riscv"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_CONFIGURATION) == ""
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_IMAGE) == "arch/riscv/boot/Image"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL) == "riscv64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL_LINKER) == "riscv64"
assert getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET) == "riscv64-glaucus-linux-musl"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_UCONTEXT) == "riscv64"
