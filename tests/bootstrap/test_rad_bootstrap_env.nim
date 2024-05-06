# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants]

rad_bootstrap_env()

echo "GLAD  :: ", getEnv($GLAD)

echo ""

echo "BAKD  :: ", getEnv($BAKD)
echo "CERD  :: ", getEnv($CERD)
echo "CRSD  :: ", getEnv($CRSD)
echo "LOGD  :: ", getEnv($LOGD)
echo "SRCD  :: ", getEnv($SRCD)
echo "TBLD  :: ", getEnv($TBLD)
echo "TSRC  :: ", getEnv($TSRC)
echo "TLCD  :: ", getEnv($TLCD)

echo ""

echo "PATH  :: ", getEnv($PATH)

doAssert getEnv($GLAD).endsWith("glaucus")

doAssert getEnv($BAKD).endsWith("bak")
doAssert getEnv($CERD).endsWith("cerata")
doAssert getEnv($CRSD).endsWith("cross")
doAssert getEnv($LOGD).endsWith("log")
doAssert getEnv($SRCD).endsWith("src")
doAssert getEnv($TBLD).endsWith("tmp/bld")
doAssert getEnv($TSRC).endsWith("tmp/src")
doAssert getEnv($TLCD).endsWith("toolchain")

doAssert getEnv($PATH).split(PathSep)[0].endsWith("toolchain/usr/bin")
