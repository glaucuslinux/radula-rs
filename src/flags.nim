# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, strformat, strutils], constants

proc setEnvFlags*() =
  putEnv($CFLAGS, $cflags)
  putEnv($CXXFLAGS, $cflags)
  putEnv($LDFLAGS, &"{ldflags} {cflags}")

proc setEnvFlagsOptLto*() =
  putEnv($CFLAGS, replace($cflags, $ltoflags))
  putEnv($CXXFLAGS, getEnv($CFLAGS))
  putEnv($LDFLAGS, $ldflags)
