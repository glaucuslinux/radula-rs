# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/os,
  ../../src/[bootstrap, constants]

rad_bootstrap_system_environment_pkg_config()

echo "PKG_CONFIG_LIBDIR               :: ", getEnv(RAD_ENV_PKG_CONFIG_LIBDIR)
echo "PKG_CONFIG_PATH                 :: ", getEnv(RAD_ENV_PKG_CONFIG_PATH)
echo "PKG_CONFIG_SYSROOT_DIR          :: ", getEnv(RAD_ENV_PKG_CONFIG_SYSROOT_DIR)
echo "PKG_CONFIG_SYSTEM_INCLUDE_PATH  :: ", getEnv(RAD_ENV_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
echo "PKG_CONFIG_SYSTEM_LIBRARY_PATH  :: ", getEnv(RAD_ENV_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

doAssert getEnv(RAD_ENV_PKG_CONFIG_LIBDIR) == "/usr/lib/pkgconfig"
doAssert getEnv(RAD_ENV_PKG_CONFIG_PATH) == "/usr/lib/pkgconfig"
doAssert getEnv(RAD_ENV_PKG_CONFIG_SYSROOT_DIR) == "/"
doAssert getEnv(RAD_ENV_PKG_CONFIG_SYSTEM_INCLUDE_PATH) == "/usr/include"
doAssert getEnv(RAD_ENV_PKG_CONFIG_SYSTEM_LIBRARY_PATH) == "/usr/lib"
