# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[bootstrap, constants]

rad_bootstrap_system_environment_directories()

echo "SRCD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_SOURCES)
echo "CERD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_CERATA)
echo "LOGD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_LOGS)
echo "TBLD  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_BUILDS)
echo "TSRC  :: ", getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_SOURCES)

doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_SOURCES) == "/var/cache/rad/src"
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_CERATA) == "/var/lib/rad/clusters/glaucus"
doAssert getEnv(RAD_ENVIRONMENT_DIRECTORY_LOGS) == "/var/log/rad"
doassert getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_BUILDS) == "/var/tmp/rad/bld"
doassert getEnv(RAD_ENVIRONMENT_DIRECTORY_TEMPORARY_SOURCES) == "/var/tmp/rad/src"
