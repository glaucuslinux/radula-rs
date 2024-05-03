# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, strformat, strutils, terminal, times],
  constants,
  hashlib/misc/blake3

func rad_compress_zstd*(file: string): int =
  execCmd(&"{RAD_CERAS_ZSTD} {RAD_TOOTH_ZSTD_COMPRESS_FLAGS} {file} {RAD_TOOTH_SHELL_REDIRECTION}")

func rad_create_archive_zstd*(archive, directory: string): int =
  execCmd(&"{RAD_TOOTH_TAR} --use-compress-program '{RAD_CERAS_ZSTD} {RAD_TOOTH_ZSTD_COMPRESS_FLAGS}' {RAD_TOOTH_TAR_CREATE_FLAGS} {archive} -C {directory} . {RAD_TOOTH_SHELL_REDIRECTION}")

func rad_extract_archive*(archive, directory: string): int =
  execCmd(&"{RAD_TOOTH_TAR} {RAD_TOOTH_TAR_EXTRACT_FLAGS} {archive} -C {directory} {RAD_TOOTH_SHELL_REDIRECTION}")

proc rad_exit*(status = 0) =
  remove_file(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_DIRECTORY_TEMPORARY / RAD_FILE_RAD_LOCK)

  quit(status)

proc rad_abort*() {.noconv.} =
  echo ""

  styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"interrupt received\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

  rad_exit(QuitFailure)

func rad_generate_initramfs*(directory: string, bootstrap = false): int =
  execCmd(&"{RAD_CERAS_BOOSTER} build --force --compression={RAD_CERAS_ZSTD} --config={RAD_PATH_RAD_LIBRARY_CLUSTERS_GLAUCUS / RAD_CERAS_BOOSTER / RAD_FILE_BOOSTER_CONF} {(if bootstrap: \"--universal\" else: \"\")} --strip {directory / RAD_FILE_INITRAMFS_GLAUCUS}")

proc rad_generate_sum*(directory, sum: string) =
  var files: seq[string]

  for file in walkDirRec(directory, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{count[BLAKE3](try: readFile(directory / file) except CatchableError: \"\")}  {file}")

  sum.close()

proc rad_lock*() =
  if fileExists(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_DIRECTORY_TEMPORARY / RAD_FILE_RAD_LOCK):
    styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"lock exists\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

    quit(QuitFailure)
  else:
    writeFile(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / RAD_DIRECTORY_TEMPORARY / RAD_FILE_RAD_LOCK, "")

func rad_rsync*(source, destination: string, flags = RAD_TOOTH_RSYNC_FLAGS): int =
  execCmd(&"{RAD_CERAS_RSYNC} {flags} {source} {destination} --delete {RAD_TOOTH_SHELL_REDIRECTION}")

proc rad_teeth_environment*() =
  # `mawk` is the default awk implementation
  putEnv(RAD_ENVIRONMENT_TOOTH_AWK, RAD_CERAS_MAWK)
  # `byacc` is the default yacc implementation
  putEnv(RAD_ENVIRONMENT_TOOTH_BISON, RAD_CERAS_BYACC)
  # `flex` is the default lex implementation
  putEnv(RAD_ENVIRONMENT_TOOTH_FLEX, RAD_CERAS_FLEX)
  putEnv(RAD_ENVIRONMENT_TOOTH_LEX, RAD_CERAS_FLEX)
  # `make` and its flags
  putEnv(RAD_ENVIRONMENT_TOOTH_MAKE, RAD_CERAS_MAKE)
  putEnv(RAD_ENVIRONMENT_TOOTH_MAKEFLAGS, RAD_TOOTH_MAKEFLAGS)
  # `pkgconf` is the default pkg-config implementation
  putEnv(RAD_ENVIRONMENT_TOOTH_PKG_CONFIG, RAD_CERAS_PKGCONF)
  putEnv(RAD_ENVIRONMENT_TOOTH_RAD_RSYNC_FLAGS, RAD_TOOTH_RSYNC_FLAGS)
  # `byacc` is the default yacc implementation
  putEnv(RAD_ENVIRONMENT_TOOTH_YACC, RAD_CERAS_BYACC)

proc rad_verify_file*(file, sum: string): bool =
  $count[BLAKE3](try: readFile(file) except CatchableError: "") == sum

proc rad_verify_sum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](try: readFile(line[1]) except CatchableError: "") != line[0]:
      echo line[1], ": FAILED"
