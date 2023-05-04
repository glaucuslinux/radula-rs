# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  strutils
]

import
  ../../src/bootstrap,
  ../../src/constants

radula_behave_bootstrap_environment()

radula_behave_bootstrap_cross_environment_directories()

radula_behave_bootstrap_cross_ccache()

echo "CCACHE_DIR         :: ", getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY)
echo "PATH               :: ", getEnv(RADULA_ENVIRONMENT_PATH)

doAssert getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY).endsWith("tmp/cross/ccache")
# check if the `/` in `/toolchain...` is needed or not
doAssert getEnv(RADULA_ENVIRONMENT_PATH).split(':')[0].endsWith("/toolchain/usr/lib/ccache")
