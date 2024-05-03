# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, strformat, strutils, terminal, times],
  constants,
  hashlib/misc/blake3

func rad_compress_zst*(file: string): int =
  execCmd(&"{RAD_CERAS_ZSTD} {RAD_FLAGS_TOOTH_ZSTD_COMPRESS} {file} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

func rad_create_tar_zst*(archive, directory: string): int =
  execCmd(&"{RAD_TOOTH_TAR} --use-compress-program '{RAD_CERAS_ZSTD} {RAD_FLAGS_TOOTH_ZSTD_COMPRESS}' {RAD_FLAGS_TOOTH_TAR_CREATE} {archive} -C {directory} . {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

func rad_extract_tar*(archive, directory: string): int =
  execCmd(&"{RAD_TOOTH_TAR} {RAD_FLAGS_TOOTH_TAR_EXTRACT} {archive} -C {directory} {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

proc rad_exit*(status = 0) =
  remove_file(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_DIR_TMP / RAD_FILE_RAD_LOCK)

  quit(status)

proc rad_abort*(err: string) =
  styled_echo fg_red, style_bright, &"ABORT!  {err}{now().format(\"hh:mm tt\")}", reset_style

  rad_exit(QuitFailure)

proc rad_interrupt*() {.noconv.} =
  rad_abort(&"{\"interrupt received\":48}{\"1\":8}")

func rad_gen_initramfs*(directory: string, bootstrap = false): int =
  execCmd(&"{RAD_CERAS_BOOSTER} build --force --compression={RAD_CERAS_ZSTD} --config={RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_BOOSTER / RAD_FILE_BOOSTER_YAML} {(if bootstrap: \"--universal\" else: \"\")} --strip {directory / RAD_FILE_INITRAMFS}")

proc rad_gen_sum*(directory, sum: string) =
  var files: seq[string]

  for file in walkDirRec(directory, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{count[BLAKE3](try: readFile(directory / file) except CatchableError: \"\")}  {file}")

  sum.close()

proc rad_lock*() =
  if fileExists(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_DIR_TMP / RAD_FILE_RAD_LOCK):
    rad_abort(&"{\"lock exists\":48}{\"1\":8}")
  else:
    writeFile(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_DIR_TMP / RAD_FILE_RAD_LOCK, "")

func rad_rsync*(src, dst: string, flags = RAD_FLAGS_TOOTH_RSYNC): int =
  execCmd(&"{RAD_CERAS_RSYNC} {flags} {src} {dst} --delete {RAD_FLAGS_TOOTH_SHELL_REDIRECT}")

proc rad_teeth_env*() =
  # `mawk` is the default awk implementation
  putEnv(RAD_ENV_TOOTH_AWK, RAD_CERAS_MAWK)
  # `byacc` is the default yacc implementation
  putEnv(RAD_ENV_TOOTH_BISON, RAD_CERAS_BYACC)
  # `flex` is the default lex implementation
  putEnv(RAD_ENV_TOOTH_FLEX, RAD_CERAS_FLEX)
  putEnv(RAD_ENV_TOOTH_LEX, RAD_CERAS_FLEX)
  # `make` and its flags
  putEnv(RAD_ENV_TOOTH_MAKE, RAD_CERAS_MAKE)
  putEnv(RAD_ENV_TOOTH_MAKEFLAGS, RAD_FLAGS_TOOTH_MAKE)
  # `pkgconf` is the default pkg-config implementation
  putEnv(RAD_ENV_TOOTH_PKG_CONFIG, RAD_CERAS_PKGCONF)
  putEnv(RAD_ENV_TOOTH_RAD_RSYNC_FLAGS, RAD_FLAGS_TOOTH_RSYNC)
  # `byacc` is the default yacc implementation
  putEnv(RAD_ENV_TOOTH_YACC, RAD_CERAS_BYACC)

proc rad_verify_file*(file, sum: string): bool =
  $count[BLAKE3](try: readFile(file) except CatchableError: "") == sum

proc rad_verify_sum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](try: readFile(line[1]) except CatchableError: "") != line[0]:
      echo line[1], ": FAILED"
