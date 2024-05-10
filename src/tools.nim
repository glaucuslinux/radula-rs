# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, strformat, strutils, terminal, times],
  constants,
  hashlib/misc/blake3

proc gitCheckoutRepo*(dir, cmt: string): int =
  execCmd(&"{git} -C {dir} {gitCheckout} {cmt} -q")

proc gitCloneRepo*(url, dir: string): int =
  execCmd(&"{git} {gitClone} {url} {dir} -q")

func compressZst*(file: string): int =
  execCmd(&"{zstd} {zstdCompress} {file} {shellRedirect}")

func createTarZst*(archive, dir: string): int =
  execCmd(&"{tar} --use-compress-program '{zstd} {zstdCompress}' {tarCreate} {archive} -C {dir} {CurDir} {shellRedirect}")

proc downloadFile*(file, url: string): int =
  execCmd(&"{wget2} -q -O {file} -c -N {url}")

proc exit*(status = 0) =
  removeFile(DirSep & $tmp / $radLck)

  quit(status)

func extractTar*(archive, dir: string): int =
  execCmd(&"{tar} {tarExtract} {archive} -C {dir} {shellRedirect}")

proc abort*(err: string) =
  styledEcho fgRed, styleBright, &"""{err}{"abort":8}{now().format("hh:mm tt")}""", resetStyle

  exit(QuitFailure)

func genInitramfs*(dir: string, bootstrap = false): int =
  execCmd(&"""{booster} {build} --force --compression={zstd} --config={$radLibClustersGlaucus / $booster / $boosterYaml} {(if bootstrap: "--universal" else: "")} --strip {dir / $initramfs}""")

proc genSum*(dir, sum: string) =
  var files: seq[string]

  for file in walkDirRec(dir, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{count[BLAKE3](readFile(dir / file))}  {file}")

  sum.close()

proc interrupt*() {.noconv.} =
  abort(&"""{"1":8}{"interrupt received":48}""")

proc lock*() =
  if fileExists(DirSep & $tmp / $radLck):
    abort(&"""{"1":8}{"lck exists":48}""")
  else:
    writeFile(DirSep & $tmp / $radLck, "")

func rsync*(src, dest: string, flags = RSYNC): int =
  execCmd(&"{radCerata.rsync} {flags} {src} {dest} --delete {shellRedirect}")

proc setEnvTools*() =
  putEnv($AWK, $mawk)
  putEnv($BISON, $byacc)
  putEnv($FLEX, $flex)
  putEnv($LEX, $flex)
  putEnv($MAKE, $radCerata.make)
  putEnv($MAKEFLAGS, $radFlags.make)
  putEnv($PKG_CONFIG, $pkgconf)
  putEnv($RAD_RSYNC_FLAGS, $RSYNC)
  putEnv($YACC, $byacc)

proc verifyFile*(file, sum: string): bool =
  $count[BLAKE3](readFile(file)) == sum

proc verifySum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](readFile(line[1])) != line[0]:
      echo line[1], ": FAILED"
