# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import strutils

import ../../src/bootstrap
import ../../src/constants

radula_behave_bootstrap_environment()

echo "GLAD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS)

echo "BAKD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS)
echo "CERD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA)
echo "CRSD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS)
echo "LOGD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS)
echo "SRCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES)
echo "TMPD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY)
echo "TLCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN)

echo "PATH  :: ", getEnv(RADULA_ENVIRONMENT_PATH)

assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS).endsWith("glaucus")

assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS).endsWith("bak")
assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA).endsWith("cerata")
assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS).endsWith("cross")
assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS).endsWith("log")
assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES).endsWith("src")
assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY).endsWith("tmp")
assert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN).endsWith("toolchain")

assert getEnv(RADULA_ENVIRONMENT_PATH).split(':')[0].endsWith("toolchain/usr/bin")
