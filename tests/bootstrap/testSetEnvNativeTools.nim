# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os, ../../src/[arch, bootstrap, constants]

setEnvArch()
setEnvNativeTools()

echo "AR          :: ", getEnv($AR)
echo "AS          :: ", getEnv($radEnv.AS)
echo "AWK         :: ", getEnv($AWK)
echo "CC          :: ", getEnv($CC)
echo "CPP         :: ", getEnv($radEnv.CPP)
echo "CXX         :: ", getEnv($CXX)
echo "CXXCPP      :: ", getEnv($CXXCPP)
echo "HOSTCC      :: ", getEnv($HOSTCC)
echo "LEX         :: ", getEnv($LEX)
echo "LIBTOOL     :: ", getEnv($LIBTOOL)
echo "NM          :: ", getEnv($NM)
echo "OBJCOPY     :: ", getEnv($OBJCOPY)
echo "OBJDUMP     :: ", getEnv($OBJDUMP)
echo "PKG_CONFIG  :: ", getEnv($PKG_CONFIG)
echo "RANLIB      :: ", getEnv($RANLIB)
echo "READELF     :: ", getEnv($READELF)
echo "SIZE        :: ", getEnv($SIZE)
echo "STRIP       :: ", getEnv($STRIP)

doAssert getEnv($AR) == "gcc-ar"
doAssert getEnv($radEnv.AS) == "as"
doAssert getEnv($AWK) == "mawk"
doAssert getEnv($CC) == "gcc"
doAssert getEnv($radEnv.CPP) == "gcc -E"
doAssert getEnv($CXX) == "g++"
doAssert getEnv($HOSTCC) == "gcc"
doAssert getEnv($LEX) == "flex"
doAssert getEnv($LIBTOOL) == "slibtool"
doAssert getEnv($NM) == "gcc-nm"
doAssert getEnv($OBJCOPY) == "objcopy"
doAssert getEnv($OBJDUMP) == "objdump"
doAssert getEnv($PKG_CONFIG) == "pkgconf"
doAssert getEnv($RANLIB) == "gcc-ranlib"
doAssert getEnv($READELF) == "readelf"
doAssert getEnv($SIZE) == "size"
doAssert getEnv($STRIP) == "strip"
