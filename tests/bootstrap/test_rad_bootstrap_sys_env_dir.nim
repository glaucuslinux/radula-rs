# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[bootstrap, constants]

rad_bootstrap_sys_env_dir()

echo "SRCD  :: ", getEnv(RAD_ENV_DIR_SRCD)
echo "CERD  :: ", getEnv(RAD_ENV_DIR_CERD)
echo "LOGD  :: ", getEnv(RAD_ENV_DIR_LOGD)
echo "TBLD  :: ", getEnv(RAD_ENV_DIR_TBLD)
echo "TSRC  :: ", getEnv(RAD_ENV_DIR_TSRC)

doAssert getEnv(RAD_ENV_DIR_SRCD) == "/var/cache/rad/src"
doAssert getEnv(RAD_ENV_DIR_CERD) == "/var/lib/rad/clusters/glaucus"
doAssert getEnv(RAD_ENV_DIR_LOGD) == "/var/log/rad"
doassert getEnv(RAD_ENV_DIR_TBLD) == "/var/tmp/rad/bld"
doassert getEnv(RAD_ENV_DIR_TSRC) == "/var/tmp/rad/src"
