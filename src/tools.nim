# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, strformat, strutils, terminal, times],
  constants,
  hashlib/misc/blake3

proc compressZst*(file: string): int =
  execCmd(&"{zstd} {zstdCompress} {file} {shellRedirect}")

proc createTarZst*(archive, dir: string): int =
  execCmd(
    &"{tar} --use-compress-program '{zstd} {zstdCompress}' {tarCreate} {archive} -C {dir} {CurDir} {shellRedirect}"
  )

proc downloadFile*(file, url: string): int =
  execCmd(&"{wget2} -q -O {file} -c -N {url}")

proc exit*(status = 0) =
  removeFile($radLock)

  quit(status)

proc abort*(err: string) =
  styledEcho fgRed, styleBright, &"""{err}{"abort":8}{now().format("hh:mm tt")}"""

  exit(QuitFailure)

proc extractTar*(archive, dir: string): int =
  execCmd(&"{tar} {tarExtract} {archive} -C {dir} {shellRedirect}")

proc genSum*(dir, sum: string) =
  var files: seq[string]

  for file in walkDirRec(dir, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{count[BLAKE3](readFile(dir / file))}  {file}")

  sum.close()

proc gitCheckoutRepo*(dir, cmt: string): int =
  execCmd(&"{git} -C {dir} {gitCheckout} {cmt} -q")

proc gitCloneRepo*(url, dir: string): int =
  execCmd(&"{git} {gitClone} {url} {dir} -q")

proc interrupt*() {.noconv.} =
  abort(&"""{"1":8}{"interrupt received":48}""")

proc lock*() =
  if fileExists($radLock):
    abort(&"""{"1":8}{"lock exists":48}""")

  writeFile($radLock, "")

proc verifyFile*(file, sum: string): bool =
  fileExists(file) and $count[BLAKE3](readFile(file)) == sum

proc verifySum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](readFile(line[1])) != line[0]:
      echo line[1], ": FAILED"
