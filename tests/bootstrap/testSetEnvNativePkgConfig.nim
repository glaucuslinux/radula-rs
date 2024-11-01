# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/os, ../../src/[bootstrap, constants]

setEnvNativePkgConfig()

echo "PKG_CONFIG_LIBDIR               :: ", getEnv($PKG_CONFIG_LIBDIR)
echo "PKG_CONFIG_PATH                 :: ", getEnv($PKG_CONFIG_PATH)
echo "PKG_CONFIG_SYSROOT_DIR          :: ", getEnv($PKG_CONFIG_SYSROOT_DIR)
echo "PKG_CONFIG_SYSTEM_INCLUDE_PATH  :: ", getEnv($PKG_CONFIG_SYSTEM_INCLUDE_PATH)
echo "PKG_CONFIG_SYSTEM_LIBRARY_PATH  :: ", getEnv($PKG_CONFIG_SYSTEM_LIBRARY_PATH)

doAssert getEnv($PKG_CONFIG_LIBDIR) == "/usr/lib/pkgconfig"
doAssert getEnv($PKG_CONFIG_PATH) == "/usr/lib/pkgconfig"
doAssert getEnv($PKG_CONFIG_SYSROOT_DIR) == DirSep
doAssert getEnv($PKG_CONFIG_SYSTEM_INCLUDE_PATH) == "/usr/include"
doAssert getEnv($PKG_CONFIG_SYSTEM_LIBRARY_PATH) == "/usr/lib"
