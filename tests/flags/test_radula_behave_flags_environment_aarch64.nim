# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os

import ../../src/architecture
import ../../src/constants
import ../../src/flags

radula_behave_architecture_environment("aarch64")

radula_behave_flags_environment()

echo "CFLAGS    :: ", getEnv(RADULA_ENVIRONMENT_FLAGS_C_COMPILER)
echo "CXXFLAGS  :: ", getEnv(RADULA_ENVIRONMENT_FLAGS_CXX_COMPILER)
echo "LDFLAGS   :: ", getEnv(RADULA_ENVIRONMENT_FLAGS_LINKER)

doAssert getEnv(RADULA_ENVIRONMENT_FLAGS_C_COMPILER) == "-pipe -g0 -Ofast -fomit-frame-pointer -fmerge-all-constants -fmodulo-sched -fmodulo-sched-allow-regmoves -fgcse-sm -fgcse-las -fdevirtualize-at-ltrans -fira-loop-pressure -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -floop-parallelize-all -fvariable-expansion-in-unroller -falign-functions=32 -flimit-function-alignment -flto=auto -flto-compression-level=19 -fuse-linker-plugin -ftracer -funroll-loops -ffunction-sections -fdata-sections -fno-stack-protector -fuse-ld=mold -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic"
doAssert getEnv(RADULA_ENVIRONMENT_FLAGS_CXX_COMPILER) == "-pipe -g0 -Ofast -fomit-frame-pointer -fmerge-all-constants -fmodulo-sched -fmodulo-sched-allow-regmoves -fgcse-sm -fgcse-las -fdevirtualize-at-ltrans -fira-loop-pressure -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -floop-parallelize-all -fvariable-expansion-in-unroller -falign-functions=32 -flimit-function-alignment -flto=auto -flto-compression-level=19 -fuse-linker-plugin -ftracer -funroll-loops -ffunction-sections -fdata-sections -fno-stack-protector -fuse-ld=mold -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic -fno-rtti -fvisibility-inlines-hidden -fvisibility=hidden"
doAssert getEnv(RADULA_ENVIRONMENT_FLAGS_LINKER) == "-Wl,--strip-all -Wl,-z,noexecstack,-z,now,-z,relro -Wl,--as-needed -Wl,--gc-sections -Wl,--sort-common -Wl,--hash-style=gnu -pipe -g0 -Ofast -fomit-frame-pointer -fmerge-all-constants -fmodulo-sched -fmodulo-sched-allow-regmoves -fgcse-sm -fgcse-las -fdevirtualize-at-ltrans -fira-loop-pressure -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -floop-parallelize-all -fvariable-expansion-in-unroller -falign-functions=32 -flimit-function-alignment -flto=auto -flto-compression-level=19 -fuse-linker-plugin -ftracer -funroll-loops -ffunction-sections -fdata-sections -fno-stack-protector -fuse-ld=mold -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic"

