# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  strutils
]

import
  ../../src/constants,
  ../../src/genome

radula_genome_environment()

echo "ARCH    :: ", getEnv(RADULA_ENVIRONMENT_GENOME)
echo "CARCH   :: ", getEnv(RADULA_ENVIRONMENT_GENOME_CERATA)

echo ""

echo "BLD     :: ", getEnv(RADULA_ENVIRONMENT_TUPLE_BUILD)
echo "TGT     :: ", getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET)

doAssert getEnv(RADULA_ENVIRONMENT_GENOME) == "x86-64"
doAssert getEnv(RADULA_ENVIRONMENT_GENOME_CERATA) == "x86-64-v3"

doAssert getEnv(RADULA_ENVIRONMENT_TUPLE_BUILD) == radula_genome_tuple()[0].strip()
doAssert getEnv(RADULA_ENVIRONMENT_TUPLE_TARGET) == "x86_64-glaucus-linux-musl"
