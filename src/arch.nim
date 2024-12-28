# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, osproc, strformat, strutils, times], constants

proc getTuple*(): (string, int) =
  execCmdEx($radClustersCerataLib / $slibtool / $configGuess)

proc setEnvArch*(stage = native) =
  putEnv($ARCH, $x86_64)
  putEnv($BLD, getTuple()[0].strip())
  putEnv($CARCH, $x86_64_v3)
  putEnv($PRETTY_NAME, &"""{glaucus} {s6} {x86_64_v3} {now().format("YYYYMMdd")}""")
  putEnv(
    $TGT,
    $x86_64Linux &
      $(
        case stage
        of native: tupleNative
        else: tupleCross
      ),
  )
