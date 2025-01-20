# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os, ../../src/[constants, flags]

setEnvflagsNopParallel()

echo "MAKEFLAGS  :: ", getEnv($MAKEFLAGS)

doAssert getEnv($MAKEFLAGS) == "-j1 -O"
