# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os, ../../src/[bootstrap, constants]

setEnvNativeDirs()

echo "CERD  :: ", getEnv($CERD)
echo "LOGD  :: ", getEnv($LOGD)
echo "PKGD  :: ", getEnv($PKGD)
echo "SRCD  :: ", getEnv($SRCD)
echo "TMPD  :: ", getEnv($TMPD)

doAssert getEnv($CERD) == "/var/lib/rad/clusters/cerata"
doAssert getEnv($LOGD) == "/var/log/rad"
doAssert getEnv($PKGD) == "/var/cache/rad/pkg"
doAssert getEnv($SRCD) == "/var/cache/rad/src"
doassert getEnv($TMPD) == "/var/tmp/rad"
