# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    os,
    strutils
]

import ../../src/bootstrap
import ../../src/constants

radula_behave_bootstrap_environment()

radula_behave_bootstrap_toolchain_environment_directories()

echo "TLCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN)

echo ""

echo "TMPD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY)
echo "TTMP  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN)
echo "TBLD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_BUILDS)
echo "TSRC  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_SOURCES)

echo ""

echo "TLOG  :: ", getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)

doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN).endsWith("glaucus/toolchain")

doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY).endsWith("glaucus/tmp")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN).endsWith("glaucus/tmp/toolchain")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_BUILDS).endsWith("glaucus/tmp/toolchain/bld")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_TOOLCHAIN_SOURCES).endsWith("glaucus/tmp/toolchain/src")

doAssert getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG).endsWith("glaucus/log/toolchain.log")
