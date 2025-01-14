# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os, ../../src/[constants, tools]

setEnvTools()

echo "AWK         :: ", getEnv($AWK)
echo "BISON       :: ", getEnv($BISON)
echo "FLEX        :: ", getEnv($FLEX)
echo "LEX         :: ", getEnv($LEX)
echo "LIBTOOL     :: ", getEnv($LIBTOOL)
echo "MAKE        :: ", getEnv($radEnv.MAKE)
echo "MAKEFLAGS   :: ", getEnv($MAKEFLAGS)
echo "PKG_CONFIG  :: ", getEnv($PKG_CONFIG)
echo "YACC        :: ", getEnv($YACC)

doAssert getEnv($AWK) == "mawk"
doAssert getEnv($BISON) == "byacc"
doAssert getEnv($FLEX) == "flex"
doAssert getEnv($LEX) == "flex"
doAssert getEnv($LIBTOOL) == "slibtool"
doAssert getEnv($radEnv.MAKE) == "make"
doAssert getEnv($MAKEFLAGS) == "-j4 -O"
doAssert getEnv($PKG_CONFIG) == "pkgconf"
doAssert getEnv($YACC) == "byacc"
