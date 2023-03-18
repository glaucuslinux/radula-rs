# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import strutils

import ../../src/ccache
import ../../src/constants
import ../../src/cross

radula_behave_bootstrap_cross_ccache()

echo "CCACHE_CONFIGPATH  :: ", getEnv(RADULA_ENVIRONMENT_CCACHE_CONFIGURATION)
echo "CCACHE_DIR         :: ", getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY)
echo "PATH               :: ", getEnv(RADULA_ENVIRONMENT_PATH)

assert getEnv(RADULA_ENVIRONMENT_CCACHE_CONFIGURATION).endsWith("ccache.conf")
assert getEnv(RADULA_ENVIRONMENT_CCACHE_DIRECTORY).endsWith("tmp/cross/ccache")
# check if the `/` in `/toolchain...` is needed or not
assert getEnv(RADULA_ENVIRONMENT_PATH).split(':')[0].endsWith("/toolchain/usr/lib/ccache")
