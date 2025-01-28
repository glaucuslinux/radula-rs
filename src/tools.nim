# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[algorithm, os, osproc, strformat, strutils, terminal, times], constants

proc compressZst*(file: string): int =
  execCmd(&"{zstd} {zstdCompress} {file} {shellRedirect}")

proc createTarZst*(archive, dir: string): int =
  execCmd(
    &"{tar} --use-compress-program '{zstd} {zstdCompress}' -cPpf {archive} -C {dir} {CurDir}"
  )

proc downloadFile*(file, url: string): int =
  execCmd(&"{wget2} -q -O {file} -c -N {url}")

proc exit*(status = QuitSuccess) =
  removeFile($radLock)

  quit(status)

proc abort*(err: string, status = QuitFailure) =
  styledEcho fgRed, styleBright, &"""{err}{"abort":8}{now().format("hh:mm tt")}"""

  exit(status)

proc extractTar*(archive, dir: string): int =
  execCmd(&"{tar} -xmPpf {archive} -C {dir}")

proc xxhsum(file: string): string =
  execCmdEx(&"xxhsum -H2 {file}")[0].split()[0]

proc genSum*(dir, sum: string) =
  var files: seq[string]

  for file in walkDirRec(dir, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{xxhsum(dir / file)}  {file}")

  sum.close()

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
  for nom in [
    $autoconf,
    $automake,
    $bash,
    $bison,
    $bzip2,
    $flex,
    $gcc,
    $git,
    $grep,
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
    if findExe(nom).isEmptyOrWhitespace():
      abort(&"""{127:8}{&"\{nom\} not found":48}""")

proc verifyFile*(file, sum: string): bool =
  fileExists(file) and xxhsum(file) == sum
