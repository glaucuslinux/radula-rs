# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[arch, bootstrap, constants]

setEnvArch(cross)
setEnvBootstrap()
setEnvCrossTools()

echo "CROSS_COMPILE  :: ", getEnv($CROSS_COMPILE)

echo ""

echo "AR             :: ", getEnv($AR)
echo "AS             :: ", getEnv($radEnv.AS)
echo "CC             :: ", getEnv($CC)
echo "CPP            :: ", getEnv($radEnv.CPP)
echo "CXX            :: ", getEnv($CXX)
echo "CXXCPP         :: ", getEnv($CXXCPP)
echo "HOSTCC         :: ", getEnv($HOSTCC)
echo "NM             :: ", getEnv($NM)
echo "OBJCOPY        :: ", getEnv($OBJCOPY)
echo "OBJDUMP        :: ", getEnv($OBJDUMP)
echo "RANLIB         :: ", getEnv($RANLIB)
echo "READELF        :: ", getEnv($READELF)
echo "SIZE           :: ", getEnv($SIZE)
echo "STRIP          :: ", getEnv($STRIP)

doAssert getEnv($CROSS_COMPILE).endsWith("-")

doAssert getEnv($AR).endsWith("gcc-ar")
doAssert getEnv($radEnv.AS).endsWith("as")
doAssert getEnv($CC).endsWith("gcc")
doAssert getEnv($radEnv.CPP).endsWith("gcc -E")
doAssert getEnv($CXX).endsWith("g++")
doAssert getEnv($CXXCPP).endsWith("g++ -E")
doAssert getEnv($HOSTCC) == "gcc"
doAssert getEnv($NM).endsWith("gcc-nm")
doAssert getEnv($OBJCOPY).endsWith("objcopy")
doAssert getEnv($OBJDUMP).endsWith("objdump")
doAssert getEnv($RANLIB).endsWith("gcc-ranlib")
doAssert getEnv($READELF).endsWith("readelf")
doAssert getEnv($SIZE).endsWith("size")
doAssert getEnv($STRIP).endsWith("strip")
