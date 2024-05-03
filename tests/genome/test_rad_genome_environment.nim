# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[constants, genome]

rad_genome_environment()

echo "ARCH    :: ", getEnv(RAD_ENV_GENOME_ARCH)
echo "CARCH   :: ", getEnv(RAD_ENV_GENOME_ARCH_CERATA)

echo ""

echo "BLD     :: ", getEnv(RAD_ENV_TUPLE_BLD)
echo "TGT     :: ", getEnv(RAD_ENV_TUPLE_TGT)

doAssert getEnv(RAD_ENV_GENOME_ARCH) == "x86-64"
doAssert getEnv(RAD_ENV_GENOME_ARCH_CERATA) == "x86-64-v3"

doAssert getEnv(RAD_ENV_TUPLE_BLD) == rad_genome_tuple()[0].strip()
doAssert getEnv(RAD_ENV_TUPLE_TGT) == "x86_64-glaucus-linux-musl"
