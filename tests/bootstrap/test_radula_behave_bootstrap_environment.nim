# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  strutils
]

import
  ../../src/bootstrap,
  ../../src/constants

radula_behave_bootstrap_environment()

echo "GLAD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS)

echo ""

echo "BAKD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS)
echo "CERD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA)
echo "CRSD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS)
echo "LOGD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS)
echo "SRCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES)
echo "TMPD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY)
echo "TLCD  :: ", getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN)

echo ""

echo "PATH  :: ", getEnv(RADULA_ENVIRONMENT_PATH)

doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_GLAUCUS).endsWith("glaucus")

doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_BACKUPS).endsWith("bak")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CERATA).endsWith("cerata")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_CROSS).endsWith("cross")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_LOGS).endsWith("log")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_SOURCES).endsWith("src")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TEMPORARY).endsWith("tmp")
doAssert getEnv(RADULA_ENVIRONMENT_DIRECTORY_TOOLCHAIN).endsWith("toolchain")

doAssert getEnv(RADULA_ENVIRONMENT_PATH).split(':')[0].endsWith("toolchain/usr/bin")
