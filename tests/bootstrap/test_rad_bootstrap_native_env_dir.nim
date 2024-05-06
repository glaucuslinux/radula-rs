# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[bootstrap, constants]

rad_bootstrap_native_env_dir()

echo "CERD  :: ", getEnv($CERD)
echo "LOGD  :: ", getEnv($LOGD)
echo "SRCD  :: ", getEnv($SRCD)
echo "TBLD  :: ", getEnv($TBLD)
echo "TSRC  :: ", getEnv($TSRC)

doAssert getEnv($SRCD) == "/var/cache/rad/src"
doAssert getEnv($CERD) == "/var/lib/rad/clusters/glaucus"
doAssert getEnv($LOGD) == "/var/log/rad"
doassert getEnv($TBLD) == "/var/tmp/rad/bld"
doassert getEnv($TSRC) == "/var/tmp/rad/src"
