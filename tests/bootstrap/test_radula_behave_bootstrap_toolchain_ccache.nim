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

radula_behave_bootstrap_toolchain_environment_directories()

radula_behave_bootstrap_toolchain_ccache()

echo "CCACHE_DIR         :: ", getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY)
echo "PATH               :: ", getEnv(RADULA_ENVIRONMENT_PATH)

doAssert getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY).endsWith("tmp/toolchain/ccache")
doAssert getEnv(RADULA_ENVIRONMENT_PATH).startsWith("/usr/lib/ccache:/usr/lib/ccache/bin:/usr/lib64/ccache")
