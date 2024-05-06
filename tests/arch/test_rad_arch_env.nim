# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[arch, constants]

rad_arch_env(RAD_STAGE_CROSS)

echo "ARCH    :: ", getEnv(RAD_ENV_ARCH)
echo "CARCH   :: ", getEnv(RAD_ENV_CARCH)

echo ""

echo "BLD     :: ", getEnv(RAD_ENV_TUPLE_BLD)
echo "TGT     :: ", getEnv(RAD_ENV_TUPLE_TGT)

doAssert getEnv(RAD_ENV_ARCH) == "x86-64"
doAssert getEnv(RAD_ENV_CARCH) == "x86-64-v3"

doAssert getEnv(RAD_ENV_TUPLE_BLD) == rad_arch_tuple()[0].strip()
doAssert getEnv(RAD_ENV_TUPLE_TGT) == "x86_64-glaucus-linux-musl"
