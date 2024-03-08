# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  strutils
]

import
  ../../src/bootstrap,
  ../../src/constants

radula_bootstrap_environment()

echo "GLAD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS)

echo ""

echo "BAKD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS)
echo "SRCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_SOURCES)
echo "CERD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA)
echo "CRSD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS)
echo "LOGD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS)
echo "TBLD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_BUILDS)
echo "TSRC  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_SOURCES)
echo "TLCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN)

echo ""

echo "TLOG  :: ", getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)
echo "XLOG  :: ", getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)

echo ""

echo "PATH  :: ", getEnv(RADULA_ENVIRONMENT_PATH)

doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS).endsWith("glaucus")

doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS).endsWith("bak")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_SOURCES).endsWith("src")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA).endsWith("cerata")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS).endsWith("cross")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS).endsWith("log")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_BUILDS).endsWith("tmp/bld")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY_SOURCES).endsWith("tmp/src")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN).endsWith("toolchain")

doAssert getEnv(RADULA_ENVIRONMENT_PATH).split(':')[0].endsWith("toolchain/usr/bin")
