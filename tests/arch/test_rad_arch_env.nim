# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[arch, constants]

rad_arch_env(cross)

echo "ARCH    :: ", getEnv($ARCH)
echo "CARCH   :: ", getEnv($CARCH)

echo ""

echo "BLD     :: ", getEnv($BLD)
echo "TGT     :: ", getEnv($TGT)

doAssert getEnv($ARCH) == "x86-64"
doAssert getEnv($CARCH) == "x86-64-v3"

doAssert getEnv($BLD) == rad_arch_tuple()[0].strip()
doAssert getEnv($TGT) == "x86_64-glaucus-linux-musl"
