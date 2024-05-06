# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, strformat, strutils, terminal, times],
  constants,
  hashlib/misc/blake3

proc rad_checkout_repo*(cmt, dir: string): int =
  execCmd(&"{RAD_TOOL_GIT} -C {dir} {RAD_FLAGS_TOOL_GIT_CHECKOUT} {cmt} -q")

proc rad_clone_repo*(dir, url: string): int =
  execCmd(&"{RAD_TOOL_GIT} {RAD_FLAGS_TOOL_GIT_CLONE} {url} {dir} -q")

func rad_compress_zst*(file: string): int =
  execCmd(&"{RAD_CERAS_ZSTD} {RAD_FLAGS_TOOL_ZSTD_COMPRESS} {file} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

func rad_create_tar_zst*(archive, dir: string): int =
  execCmd(&"{RAD_TOOL_TAR} --use-compress-program '{RAD_CERAS_ZSTD} {RAD_FLAGS_TOOL_ZSTD_COMPRESS}' {RAD_FLAGS_TOOL_TAR_CREATE} {archive} -C {dir} . {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

proc rad_download_file*(file, url: string): int =
  execCmd(&"{RAD_CERAS_WGET2} -q -O {file} -c -N {url}")

proc rad_exit*(status = 0) =
  remove_file(DirSep & RAD_DIR_TMP / RAD_FILE_RAD_LCK)

  quit(status)

func rad_extract_tar*(archive, dir: string): int =
  execCmd(&"{RAD_TOOL_TAR} {RAD_FLAGS_TOOL_TAR_EXTRACT} {archive} -C {dir} {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

proc rad_abort*(err: string) =
  styled_echo fg_red, style_bright, &"{err}{\"abort\":8}{now().format(\"hh:mm tt\")}", reset_style

  rad_exit(QuitFailure)

func rad_gen_initramfs*(dir: string, bootstrap = false): int =
  execCmd(&"{RAD_CERAS_BOOSTER} build --force --compression={RAD_CERAS_ZSTD} --config={RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_BOOSTER / RAD_FILE_BOOSTER_YAML} {(if bootstrap: \"--universal\" else: \"\")} --strip {dir / RAD_FILE_INITRAMFS}")

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
  rad_abort(&"{\"1\":8}{\"interrupt received\":48}")

proc rad_lck*() =
  if fileExists(DirSep & RAD_DIR_TMP / RAD_FILE_RAD_LCK):
    rad_abort(&"{\"1\":8}{\"lck exists\":48}")
  else:
    writeFile(DirSep & RAD_DIR_TMP / RAD_FILE_RAD_LCK, "")

func rad_rsync*(src, dest: string, flags = RAD_FLAGS_TOOL_RSYNC): int =
  execCmd(&"{RAD_CERAS_RSYNC} {flags} {src} {dest} --delete {RAD_FLAGS_TOOL_SHELL_REDIRECT}")

proc rad_tools_env*() =
  # `mawk` is the default awk implementation
  putEnv(RAD_ENV_TOOL_AWK, RAD_CERAS_MAWK)
  # `byacc` is the default yacc implementation
  putEnv(RAD_ENV_TOOL_BISON, RAD_CERAS_BYACC)
  # `flex` is the default lex implementation
  putEnv(RAD_ENV_TOOL_FLEX, RAD_CERAS_FLEX)
  putEnv(RAD_ENV_TOOL_LEX, RAD_CERAS_FLEX)
  # `make` and its flags
  putEnv(RAD_ENV_TOOL_MAKE, RAD_CERAS_MAKE)
  putEnv(RAD_ENV_TOOL_MAKEFLAGS, RAD_FLAGS_TOOL_MAKE)
  # `pkgconf` is the default pkg-config implementation
  putEnv(RAD_ENV_TOOL_PKG_CONFIG, RAD_CERAS_PKGCONF)
  putEnv(RAD_ENV_TOOL_RAD_RSYNC_FLAGS, RAD_FLAGS_TOOL_RSYNC)
  # `byacc` is the default yacc implementation
  putEnv(RAD_ENV_TOOL_YACC, RAD_CERAS_BYACC)

proc rad_verify_file*(file, sum: string): bool =
  $count[BLAKE3](readFile(file)) == sum

proc rad_verify_sum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](readFile(line[1])) != line[0]:
      echo line[1], ": FAILED"
