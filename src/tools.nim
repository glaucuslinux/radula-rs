# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, strformat, strutils, terminal, times],
  constants,
  hashlib/misc/blake3

proc rad_checkout_repo*(cmt, dir: string): int =
  execCmd(&"{git} -C {dir} {GIT_CHECKOUT} {cmt} -q")

proc rad_clone_repo*(dir, url: string): int =
  execCmd(&"{git} {GIT_CLONE} {url} {dir} -q")

func rad_compress_zst*(file: string): int =
  execCmd(&"{zstd} {ZSTD_COMPRESS} {file} {SHELL_REDIRECT}")

func rad_create_tar_zst*(archive, dir: string): int =
  execCmd(&"{tar} --use-compress-program '{zstd} {ZSTD_COMPRESS}' {TAR_CREATE} {archive} -C {dir} {CurDir} {SHELL_REDIRECT}")

proc rad_download_file*(file, url: string): int =
  execCmd(&"{wget2} -q -O {file} -c -N {url}")

proc rad_exit*(status = 0) =
  removeFile(DirSep & $tmp / $rad_lck)

  quit(status)

func rad_extract_tar*(archive, dir: string): int =
  execCmd(&"{tar} {TAR_EXTRACT} {archive} -C {dir} {SHELL_REDIRECT}")

proc rad_abort*(err: string) =
  styled_echo fgRed, styleBright, &"""{err}{"abort":8}{now().format("hh:mm tt")}""", resetStyle

  rad_exit(QuitFailure)

func rad_gen_initramfs*(dir: string, bootstrap = false): int =
  execCmd(&"""{booster} {build} --force --compression={zstd} --config={$RAD_LIB_CLUSTERS_GLAUCUS / $booster / $booster_yaml} {(if bootstrap: "--universal" else: "")} --strip {dir / $initramfs}""")

proc rad_gen_sum*(dir, sum: string) =
  var files: seq[string]

  for file in walkDirRec(dir, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{count[BLAKE3](readFile(dir / file))}  {file}")

  sum.close()

proc rad_interrupt*() {.noconv.} =
  rad_abort(&"""{"1":8}{"interrupt received":48}""")

proc rad_lck*() =
  if fileExists(DirSep & $tmp / $rad_lck):
    rad_abort(&"""{"1":8}{"lck exists":48}""")
  else:
    writeFile(DirSep & $tmp / $rad_lck, "")

func rad_rsync*(src, dest: string, flags = RSYNC): int =
  execCmd(&"{rsync} {flags} {src} {dest} --delete {SHELL_REDIRECT}")

proc rad_tools_env*() =
  # `mawk` is the default awk implementation
  putEnv($AWK, $mawk)
  # `byacc` is the default yacc implementation
  putEnv($BISON, $byacc)
  # `flex` is the default lex implementation
  putEnv($FLEX, $flex)
  putEnv($LEX, $flex)
  # `make` and its flags
  putEnv($RAD_ENV.MAKE, $make)
  putEnv($MAKEFLAGS, $RAD_FLAGS.MAKE)
  # `pkgconf` is the default pkg-config implementation
  putEnv($PKG_CONFIG, $pkgconf)
  putEnv($RAD_RSYNC_FLAGS, $RSYNC)
  # `byacc` is the default yacc implementation
  putEnv($YACC, $byacc)

proc rad_verify_file*(file, sum: string): bool =
  $count[BLAKE3](readFile(file)) == sum

proc rad_verify_sum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](readFile(line[1])) != line[0]:
      echo line[1], ": FAILED"
