# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  constants

# Get tuple from `config.guess`
proc rad_arch_tuple*(): (string, int) =
  execCmdEx($RAD_LIB_CLUSTERS_GLAUCUS / $binutils / $config_guess)

proc rad_arch_env*(stage = native) =
  putEnv($ARCH, $X86_64)
  putEnv($CARCH, $X86_64_V3)
  putEnv($PRETTY_NAME, &"""{glaucus} {s6} {X86_64_V3} {now().format("YYYYMMdd")}""")

  putEnv($BLD, rad_arch_tuple()[0].strip())
  putEnv($TGT, $X86_64_LINUX & $(
    case stage
    of native:
      TUPLE_NATIVE
    else:
      TUPLE_CROSS
  ))

proc rad_arch_env_flags*() =
  putEnv($RAD_ENV.CFLAGS, $RAD_FLAGS.CFLAGS)
  putEnv($CXXFLAGS, $RAD_FLAGS.CFLAGS)
  putEnv($RAD_ENV.LDFLAGS, &"{RAD_FLAGS.LDFLAGS} {RAD_FLAGS.CFLAGS}")
