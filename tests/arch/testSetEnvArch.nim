# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, strutils], ../../src/[arch, constants]

setEnvArch(cross)

echo "ARCH         :: ", getEnv($ARCH)
echo "BLD          :: ", getEnv($BLD)
echo "CARCH        :: ", getEnv($CARCH)
echo "PRETTY_NAME  :: ", getEnv($PRETTY_NAME)
echo "TGT          :: ", getEnv($TGT)

doAssert getEnv($ARCH) == "x86-64"
doAssert getEnv($BLD).startsWith("x86_64-pc-linux-")
doAssert getEnv($CARCH) == "x86-64-v3"
doAssert getEnv($PRETTY_NAME).startsWith("glaucus s6 x86-64-v3 ")
doAssert getEnv($TGT) == "x86_64-glaucus-linux-musl"
