# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  constants

# Get tuple from `config.guess`
proc rad_arch_tuple*(): (string, int) =
  execCmdEx(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_BINUTILS / RAD_FILE_CONFIG_GUESS)

proc rad_arch_env*(stage = RAD_STAGE_NATIVE) =
  putEnv(RAD_ENV_ARCH, RAD_ARCH_X86_64)
  putEnv(RAD_ENV_CARCH, RAD_ARCH_X86_64_V3)
  putEnv(RAD_ENV_PRETTY_NAME, &"""{RAD_GLAUCUS} {RAD_CERAS_S6} {RAD_ARCH_X86_64_V3} {now().format("YYYYMMdd")}""")

  putEnv(RAD_ENV_TUPLE_BLD, rad_arch_tuple()[0].strip())
  putEnv(RAD_ENV_TUPLE_TGT, RAD_ARCH_X86_64_LINUX & (
    case stage
    of RAD_STAGE_NATIVE:
      RAD_ARCH_TUPLE_TGT_NATIVE
    else:
      RAD_ARCH_TUPLE_TGT_CROSS
  ))

proc rad_arch_env_flags*() =
  putEnv(RAD_ENV_FLAGS_CFLAGS, RAD_FLAGS_CFLAGS)
  putEnv(RAD_ENV_FLAGS_CXXFLAGS, RAD_FLAGS_CFLAGS)
  putEnv(RAD_ENV_FLAGS_LDFLAGS, &"{RAD_FLAGS_LDFLAGS} {RAD_FLAGS_CFLAGS}")
