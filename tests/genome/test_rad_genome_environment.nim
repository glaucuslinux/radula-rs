# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[constants, genome]

rad_genome_environment()

echo "ARCH    :: ", getEnv(RAD_ENVIRONMENT_GENOME)
echo "CARCH   :: ", getEnv(RAD_ENVIRONMENT_GENOME_CERATA)

echo ""

echo "BLD     :: ", getEnv(RAD_ENVIRONMENT_TUPLE_BUILD)
echo "TGT     :: ", getEnv(RAD_ENVIRONMENT_TUPLE_TARGET)

doAssert getEnv(RAD_ENVIRONMENT_GENOME) == "x86-64"
doAssert getEnv(RAD_ENVIRONMENT_GENOME_CERATA) == "x86-64-v3"

doAssert getEnv(RAD_ENVIRONMENT_TUPLE_BUILD) == rad_genome_tuple()[0].strip()
doAssert getEnv(RAD_ENVIRONMENT_TUPLE_TARGET) == "x86_64-glaucus-linux-musl"
