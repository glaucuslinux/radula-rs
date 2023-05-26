# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os

import
  ../../src/bootstrap,
  ../../src/constants

radula_behave_bootstrap_system_environment_pkg_config()

echo "PKG_CONFIG_LIBDIR               :: ", getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_LIBDIR)
echo "PKG_CONFIG_PATH                 :: ", getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_PATH)
echo "PKG_CONFIG_SYSROOT_DIR          :: ", getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSROOT_DIR)
echo "PKG_CONFIG_SYSTEM_INCLUDE_PATH  :: ", getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
echo "PKG_CONFIG_SYSTEM_LIBRARY_PATH  :: ", getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

doAssert getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_LIBDIR) == "/usr/lib/pkgconfig"
doAssert getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_PATH) == "/usr/lib/pkgconfig"
doAssert getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSROOT_DIR) == "/"
doAssert getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_INCLUDE_PATH) == "/usr/include"
doAssert getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_LIBRARY_PATH) == "/usr/lib"
