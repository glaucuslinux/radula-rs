# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import strutils

import ../../src/bootstrap
import ../../src/constants
import ../../src/cross

radula_behave_bootstrap_environment()

radula_behave_bootstrap_cross_environment_directories()

echo "CRSD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS)

echo ""

echo "TMPD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY)
echo "XTMP  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS)
echo "XBLD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS)
echo "XSRC  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_SOURCES)

echo ""

echo "XLOG  :: ", getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)

doassert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS).endsWith("glaucus/cross")

doassert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY).endsWith("glaucus/tmp")
doassert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS).endsWith("glaucus/tmp/cross")
doassert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_BUILDS).endsWith("glaucus/tmp/cross/bld")
doassert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_CROSS_SOURCES).endsWith("glaucus/tmp/cross/src")

doassert getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG).endsWith("glaucus/log/cross.log")
