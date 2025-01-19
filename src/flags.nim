# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, strformat, strutils], constants

proc setEnvFlags*() =
  putEnv($CFLAGS, $cflags)
  putEnv($CXXFLAGS, $cflags)
  putEnv($LDFLAGS, &"{ldflags} {cflags}")
  putEnv($MAKEFLAGS, $radFlags.make)

proc setEnvFlagsOptLto*() =
  putEnv($CFLAGS, replace($cflags, $radFlags.lto))
  putEnv($CXXFLAGS, getEnv($CFLAGS))
  putEnv($LDFLAGS, $ldflags)
  putEnv($MAKEFLAGS, $radFlags.make)

proc setEnvFlagsOptParallel*() =
  putEnv($MAKEFLAGS, $radFlags.parallel)
