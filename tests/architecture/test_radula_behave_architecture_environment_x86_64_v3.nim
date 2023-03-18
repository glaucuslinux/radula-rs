# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os

import ../../src/architecture
import ../../src/constants

radula_behave_architecture_environment("x86-64")

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

assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE) == "x86-64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_CERATA) == "--with-gcc-arch=x86-64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_FLAGS) == "-march=x86-64-v3 -mtune=generic -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_GCC_CONFIGURATION) == "--with-arch=x86-64-v3 --with-tune=generic"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX) == "x86_64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_CONFIGURATION) == "x86_64_"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_LINUX_IMAGE) == "arch/x86/boot/bzImage"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL) == "x86_64"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_MUSL_LINKER) == "x86_64"
assert getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET) == "x86_64-glaucus-linux-musl"
assert getEnv(RADULA_ENVIRONMENT_ARCHITECTURE_UCONTEXT) == "x86_64"
