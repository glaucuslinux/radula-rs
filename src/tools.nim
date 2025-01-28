# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[algorithm, os, osproc, strformat, strutils, terminal, times], constants

proc createTarZst*(archive, dir: string): int =
  execCmd(
    &"{tar} --use-compress-program '{zstd} {zstdCompress}' -cPpf {archive} -C {dir} ."
  )

proc downloadFile*(url, file: string): int =
  execCmd(&"{wget2} -q -O {file} -c -N {url}")

proc exit*(status = QuitSuccess) =
  removeFile($radLock)

  quit(status)

proc abort*(err: string, status = QuitFailure) =
  styledEcho fgRed, styleBright, &"""{err}{"abort":8}{now().format("hh:mm tt")}"""

  exit(status)

proc extractTar*(archive, dir: string): int =
  execCmd(&"{tar} -xmPpf {archive} -C {dir}")

proc genFiles*(dir, files: string) =
  var items: seq[string]

  for item in walkDirRec(dir, relative = true, skipSpecial = true):
    items.add(item)

  sort(items)

  let files = open(files, fmWrite)

  for item in items:
    files.writeLine(item)

  files.close()

proc gitCheckoutRepo*(dir, cmt: string): int =
  execCmd(&"{git} -C {dir} checkout {cmt} -q")

proc gitCloneRepo*(url, dir: string): int =
  execCmd(&"{git} clone {url} {dir} -q")

proc interrupt*() {.noconv.} =
  abort(&"""{$QuitFailure:8}{"interrupt received":48}""")

proc lock*() =
  if fileExists($radLock):
    abort(&"""{$QuitFailure:8}{"lock exists":48}""")

  writeFile($radLock, "")

proc require*() =
  for exe in [
    $autoconf,
    $automake,
    $bash,
    $bison,
    $bzip2,
    $flex,
    $gcc,
    $git,
    $grep,
    $limine,
    $m4,
    $radCerata.make,
    $mawk,
    $perl,
    $pigz,
    $pkgconf,
    $tar,
    $xz,
    $zstd,
  ]:
    if findExe(exe).isEmptyOrWhitespace():
      abort(&"""{127:8}{&"\{exe\} not found":48}""")

proc xxhsum(file: string): string =
  execCmdEx(&"xxhsum -H2 {file}").output.strip()

proc verifyFile*(file, sum: string): bool =
  fileExists(file) and xxhsum(file).split()[0] == sum
