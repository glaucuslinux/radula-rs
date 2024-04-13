# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  algorithm,
  os,
  osproc,
  strformat,
  strutils,
  terminal,
  times
]

import constants

import hashlib/misc/blake3

proc radula_compress_zstd*(file: string): int =
  execCmd(&"{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_COMPRESS_FLAGS} {file} {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_create_archive_zstd*(archive, directory: string): int =
  execCmd(&"{RADULA_TOOTH_TAR} --use-compress-program '{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_COMPRESS_FLAGS}' {RADULA_TOOTH_TAR_CREATE_FLAGS} {archive} -C {directory} . {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_extract_archive*(archive, directory: string): int =
  execCmd(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {archive} -C {directory} {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_extract_archive_zstd*(archive, directory: string): int =
  execCmd(&"{RADULA_TOOTH_TAR} --use-compress-program '{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_DECOMPRESS_FLAGS}' {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {archive} -C {directory} {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_exit*(status = 0) =
  remove_file(RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_FILE_RADULA_LOCK)

  quit(status)

proc radula_abort*() {.noconv.} =
  echo ""

  styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"interrupt received\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

  radula_exit(QuitFailure)

proc radula_generate_initramfs*(directory: string, bootstrap = false) =
  discard execCmd(&"{RADULA_CERAS_BOOSTER} build --force --compression={RADULA_CERAS_ZSTD} --config={RADULA_PATH_RADULA_CLUSTERS_GLAUCUS / RADULA_CERAS_BOOSTER / RADULA_FILE_BOOSTER_CONF} {(if bootstrap: \"--universal\" else: \"\")} --strip {directory / RADULA_FILE_INITRAMFS_GLAUCUS}")

proc radula_generate_sum*(directory, sum: string) =
  var files: seq[string]

  for file in walkDirRec(directory, relative = true, skipSpecial = true):
    files.add(file)

  sort(files)

  let sum = open(sum, fmWrite)

  for file in files:
    sum.writeLine(&"{count[BLAKE3](try: readFile(directory / file) except CatchableError: \"\")}  {file}")

  sum.close()

proc radula_lock*() =
  if fileExists(RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_FILE_RADULA_LOCK):
    styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"lock exists\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

    quit(QuitFailure)
  else:
    writeFile(RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_FILE_RADULA_LOCK, "")

proc radula_rsync*(source, destination: string, flags = RADULA_TOOTH_RSYNC_FLAGS): int =
  execCmd(&"{RADULA_CERAS_RSYNC} {flags} {source} {destination} --delete {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_teeth_environment*() =
  # `mawk` is the default awk implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_AWK, RADULA_CERAS_MAWK)
  # `byacc` is the default yacc implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_BISON, RADULA_CERAS_BYACC)
  # `flex` is the default lex implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_FLEX, RADULA_CERAS_FLEX)
  putEnv(RADULA_ENVIRONMENT_TOOTH_LEX, RADULA_CERAS_FLEX)
  # `make` and its flags
  putEnv(RADULA_ENVIRONMENT_TOOTH_MAKE, RADULA_CERAS_MAKE)
  putEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS, RADULA_TOOTH_MAKEFLAGS)
  # `pkgconf` is the default pkg-config implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG, RADULA_CERAS_PKGCONF)
  putEnv(RADULA_ENVIRONMENT_TOOTH_RADULA_RSYNC_FLAGS, RADULA_TOOTH_RSYNC_FLAGS)
  # `byacc` is the default yacc implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_YACC, RADULA_CERAS_BYACC)

proc radula_verify_sum*(sum: string) =
  for line in lines(sum):
    let line = line.split()

    if $count[BLAKE3](try: readFile(line[1]) except CatchableError: "") != line[0]:
      echo line[1], ": FAILED"
