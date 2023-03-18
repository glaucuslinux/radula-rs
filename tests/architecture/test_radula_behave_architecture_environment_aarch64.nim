# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os

import ../../src/architecture
import ../../src/constants

radula_behave_architecture_environment("aarch64")

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

assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE) == "aarch64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_CERATA) == "--with-gcc-arch=armv8-a"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_FLAGS) == "-mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_GCC_CONFIGURATION) == "--with-arch=armv8-a --with-abi=lp64 --enable-fix-cortex-a53-835769 --enable-fix-cortex-a53-843419"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX) == "arm64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_CONFIGURATION) == ""
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_IMAGE) == "arch/arm64/boot/Image"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL) == "aarch64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL_LINKER) == "aarch64"
assert getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET) == "aarch64-glaucus-linux-musl"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_UCONTEXT) == "aarch64"
