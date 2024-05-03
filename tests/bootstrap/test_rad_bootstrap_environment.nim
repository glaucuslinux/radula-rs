# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants]

rad_bootstrap_environment()

echo "GLAD  :: ", getEnv(RAD_ENV_DIR_GLAD)

echo ""

echo "BAKD  :: ", getEnv(RAD_ENV_DIR_BAKD)
echo "SRCD  :: ", getEnv(RAD_ENV_DIR_SRCD)
echo "CERD  :: ", getEnv(RAD_ENV_DIR_CERD)
echo "CRSD  :: ", getEnv(RAD_ENV_DIR_CRSD)
echo "LOGD  :: ", getEnv(RAD_ENV_DIR_LOGD)
echo "TBLD  :: ", getEnv(RAD_ENV_DIR_TBLD)
echo "TSRC  :: ", getEnv(RAD_ENV_DIR_TSRC)
echo "TLCD  :: ", getEnv(RAD_ENV_DIR_TLCD)

echo ""

echo "PATH  :: ", getEnv(RAD_ENV_PATH)

doAssert getEnv(RAD_ENV_DIR_GLAD).endsWith("glaucus")

doAssert getEnv(RAD_ENV_DIR_BAKD).endsWith("bak")
doAssert getEnv(RAD_ENV_DIR_SRCD).endsWith("src")
doAssert getEnv(RAD_ENV_DIR_CERD).endsWith("cerata")
doAssert getEnv(RAD_ENV_DIR_CRSD).endsWith("cross")
doAssert getEnv(RAD_ENV_DIR_LOGD).endsWith("log")
doAssert getEnv(RAD_ENV_DIR_TBLD).endsWith("tmp/bld")
doAssert getEnv(RAD_ENV_DIR_TSRC).endsWith("tmp/src")
doAssert getEnv(RAD_ENV_DIR_TLCD).endsWith("toolchain")

doAssert getEnv(RAD_ENV_PATH).split(':')[0].endsWith("toolchain/usr/bin")
