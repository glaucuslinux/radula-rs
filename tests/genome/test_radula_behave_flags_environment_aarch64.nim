# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os

import
  ../../src/constants,
  ../../src/genome

radula_behave_genome_environment("aarch64")

radula_behave_flags_environment()

echo "CFLAGS    :: ", getEnv(RADULA_ENVIRONMENT_FLAGS_C_COMPILER)
echo "CXXFLAGS  :: ", getEnv(RADULA_ENVIRONMENT_FLAGS_CXX_COMPILER)
echo "LDFLAGS   :: ", getEnv(RADULA_ENVIRONMENT_FLAGS_LINKER)

doAssert getEnv(RADULA_ENVIRONMENT_FLAGS_C_COMPILER) == "-pipe -Werror=format-security -Wformat=2 -g0 -O2 -fdevirtualize-at-ltrans -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -Wp,-D_FORTIFY_SOURCE=3 -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic"
doAssert getEnv(RADULA_ENVIRONMENT_FLAGS_CXX_COMPILER) == "-pipe -Werror=format-security -Wformat=2 -g0 -O2 -fdevirtualize-at-ltrans -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -Wp,-D_FORTIFY_SOURCE=3 -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic -fno-rtti -fvisibility-inlines-hidden -fvisibility=hidden"
doAssert getEnv(RADULA_ENVIRONMENT_FLAGS_LINKER) == "-Wl,-O1 -Wl,-s -Wl,-z,defs,-z,noexecstack,-z,now,-z,relro -Wl,--as-needed -Wl,--gc-sections -Wl,-pie -Wl,--sort-common -Wl,--hash-style=gnu  -pipe -Werror=format-security -Wformat=2 -g0 -O2 -fdevirtualize-at-ltrans -fsched-pressure -fno-semantic-interposition -fipa-pta -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -Wp,-D_FORTIFY_SOURCE=3 -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -mabi=lp64 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419 -march=armv8-a -mtune=generic"
