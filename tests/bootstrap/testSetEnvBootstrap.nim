# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, strutils], ../../src/[bootstrap, constants]

setEnvBootstrap()

echo "GLAD  :: ", getEnv($GLAD)

echo ""

echo "CERD  :: ", getEnv($CERD)
echo "CRSD  :: ", getEnv($CRSD)
echo "LOGD  :: ", getEnv($LOGD)
echo "PKGD  :: ", getEnv($PKGD)
echo "SRCD  :: ", getEnv($SRCD)
echo "TMPD  :: ", getEnv($TMPD)
echo "TLCD  :: ", getEnv($TLCD)

echo ""

echo "PATH  :: ", getEnv($PATH)

doAssert getEnv($GLAD).endsWith("glaucus")

doAssert getEnv($CERD).endsWith("cerata")
doAssert getEnv($CRSD).endsWith("cross")
doAssert getEnv($LOGD).endsWith("log")
doAssert getEnv($PKGD).endsWith("pkg")
doAssert getEnv($SRCD).endsWith("src")
doAssert getEnv($TMPD).endsWith("tmp")
doAssert getEnv($TLCD).endsWith("toolchain")

doAssert getEnv($PATH).split(':')[0].endsWith("toolchain/usr/bin")
