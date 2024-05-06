# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, strutils],
  ../../src/[bootstrap, constants]

rad_bootstrap_env()
rad_bootstrap_cross_env_pkg_config()

echo "PKG_CONFIG_LIBDIR               :: ", getEnv($RAD_ENV.PKG_CONFIG_LIBDIR)
echo "PKG_CONFIG_PATH                 :: ", getEnv($PKG_CONFIG_PATH)
echo "PKG_CONFIG_SYSROOT_DIR          :: ", getEnv($PKG_CONFIG_SYSROOT_DIR)
echo "PKG_CONFIG_SYSTEM_INCLUDE_PATH  :: ", getEnv($RAD_ENV.PKG_CONFIG_SYSTEM_INCLUDE_PATH)
echo "PKG_CONFIG_SYSTEM_LIBRARY_PATH  :: ", getEnv($RAD_ENV.PKG_CONFIG_SYSTEM_LIBRARY_PATH)

doAssert getEnv($RAD_ENV.PKG_CONFIG_LIBDIR).endsWith("cross/usr/lib/pkgconfig")
doAssert getEnv($PKG_CONFIG_PATH).endsWith("cross/usr/lib/pkgconfig")
doAssert getEnv($PKG_CONFIG_SYSROOT_DIR).endsWith("cross/")
doAssert getEnv($RAD_ENV.PKG_CONFIG_SYSTEM_INCLUDE_PATH).endsWith("cross/usr/include")
doAssert getEnv($RAD_ENV.PKG_CONFIG_SYSTEM_LIBRARY_PATH).endsWith("cross/usr/lib")
