# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants]

setEnvBootstrap()

echo "GLAD  :: ", getEnv($GLAD)

echo ""

echo "BAKD  :: ", getEnv($BAKD)
echo "CERD  :: ", getEnv($CERD)
echo "CRSD  :: ", getEnv($CRSD)
echo "ISOD  :: ", getEnv($ISOD)
echo "LOGD  :: ", getEnv($LOGD)
echo "PKGD  :: ", getEnv($PKGD)
echo "SRCD  :: ", getEnv($SRCD)
echo "TBLD  :: ", getEnv($TBLD)
echo "TLCD  :: ", getEnv($TLCD)
echo "TSRC  :: ", getEnv($TSRC)

echo ""

echo "PATH  :: ", getEnv($PATH)

doAssert getEnv($GLAD).endsWith("glaucus")

doAssert getEnv($BAKD).endsWith("bak")
doAssert getEnv($CERD).endsWith("cerata")
doAssert getEnv($CRSD).endsWith("cross")
doAssert getEnv($ISOD).endsWith("iso")
doAssert getEnv($LOGD).endsWith("log")
doAssert getEnv($PKGD).endsWith("pkg")
doAssert getEnv($SRCD).endsWith("src")
doAssert getEnv($TBLD).endsWith("tmp/bld")
doAssert getEnv($TLCD).endsWith("toolchain")
doAssert getEnv($TSRC).endsWith("tmp/src")

doAssert getEnv($PATH).split(PathSep)[0].endsWith("toolchain/usr/bin")
