# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os

import constants

#
# pkg-config Function
#

proc radula_behave_pkg_config_environment*() =
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_LIBDIR, getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_LIBDIR_PATH)
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_PATH, getEnv(RADULA_ENVIRONMENT_PKG_CONFIG_LIBDIR))
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSROOT_DIR, getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_SYSROOT_DIR)

    # These environment variables are only `pkgconf` specific, but setting them
    # won't do any harm...
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_INCLUDE_PATH, getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
    putEnv(RADULA_ENVIRONMENT_PKG_CONFIG_SYSTEM_LIBRARY_PATH, getEnv(
        RADULA_ENVIRONMENT_DIRECTORY_CROSS) / RADULA_PATH_PKG_CONFIG_SYSTEM_LIBRARY_PATH)
