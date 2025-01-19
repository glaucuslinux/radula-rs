# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os, ../../src/[constants, flags]

setEnvflags()

echo "CFLAGS     :: ", getEnv($CFLAGS)
echo "CXXFLAGS   :: ", getEnv($CXXFLAGS)
echo "LDFLAGS    :: ", getEnv($LDFLAGS)
echo "MAKEFLAGS  :: ", getEnv($MAKEFLAGS)

doAssert getEnv($CFLAGS) ==
  "-pipe -O2 -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -march=x86-64-v3 -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
doAssert getEnv($CXXFLAGS) ==
  "-pipe -O2 -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -march=x86-64-v3 -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
doAssert getEnv($LDFLAGS) ==
  "-Wl,-O1,-s,-z,noexecstack,-z,now,-z,pack-relative-relocs,-z,relro,-z,x86-64-v3,--as-needed,--gc-sections,--sort-common,--hash-style=gnu -pipe -O2 -fgraphite-identity -floop-nest-optimize -flto=auto -flto-compression-level=19 -fuse-linker-plugin -fstack-protector-strong -fstack-clash-protection -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-plt -march=x86-64-v3 -mfpmath=sse -mabi=sysv -malign-data=cacheline -mtls-dialect=gnu2"
doAssert getEnv($MAKEFLAGS) == "-j4 -O"
