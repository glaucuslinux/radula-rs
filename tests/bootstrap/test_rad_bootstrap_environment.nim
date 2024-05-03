# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants]

rad_bootstrap_environment()

echo "GLAD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_GLAUCUS)

echo ""

echo "BAKD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_BACKUPS)
echo "SRCD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_SOURCES)
echo "CERD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_CERATA)
echo "CRSD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_CROSS)
echo "LOGD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_LOGS)
echo "TBLD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_BUILDS)
echo "TSRC  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_SOURCES)
echo "TLCD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_TOOLCHAIN)

echo ""

echo "PATH  :: ", getEnv(RAD_ENVIRONMENT_PATH)

doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_GLAUCUS).endsWith("glaucus")

doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_BACKUPS).endsWith("bak")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_SOURCES).endsWith("src")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_CERATA).endsWith("cerata")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_CROSS).endsWith("cross")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_LOGS).endsWith("log")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_BUILDS).endsWith("tmp/bld")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_SOURCES).endsWith("tmp/src")
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_TOOLCHAIN).endsWith("toolchain")

doAssert getEnv(RAD_ENVIRONMENT_PATH).split(':')[0].endsWith("toolchain/usr/bin")
