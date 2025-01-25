# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, osproc, strformat, strutils, times], constants

proc setEnvArch*(stage = native) =
  putEnv($ARCH, $x86_64)
  putEnv(
    $BLD,
    execCmdEx($radClustersCerataLib / $slibtool / $configGuess)[QuitSuccess].strip(),
  )
  putEnv($CARCH, $x86_64_v3)
  putEnv($PRETTY_NAME, &"""{glaucus} {s6} {x86_64_v3} {now().format("YYYYMMdd")}""")
  putEnv($TGT, &"{x86_64Linux}-{(if stage == native: tupleNative else: tupleCross)}")
