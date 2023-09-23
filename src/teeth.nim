# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  osproc,
  strformat,
  terminal,
  times
]

import constants

# Create `ceras` archive from directory
proc radula_behave_create_archive_zstd*(archive, directory: string): int =
  execCmd(&"{RADULA_TOOTH_TAR} --use-compress-program '{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_COMPRESS_FLAGS}' {RADULA_TOOTH_TAR_CREATE_FLAGS} {archive} -C {directory} . {RADULA_TOOTH_SHELL_REDIRECTION}")

# Extract `ceras` source archive into directory
proc radula_behave_extract_archive*(archive, directory: string): int =
  execCmd(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {archive} -C {directory} {RADULA_TOOTH_SHELL_REDIRECTION}")

# Extract `ceras` archive into directory
proc radula_behave_extract_archive_zstd*(archive, directory: string): int =
  execCmd(&"{RADULA_TOOTH_TAR} --use-compress-program '{RADULA_CERAS_ZSTD} {RADULA_TOOTH_ZSTD_DECOMPRESS_FLAGS}' {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {archive} -C {directory} {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_behave_exit*(status: int = 0) =
  remove_file(RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_FILE_RADULA_LOCK)

  quit(status)

proc radula_behave_abort*() {.noconv.} =
  echo ""

  styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"interrupt received\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

  radula_behave_exit(QuitFailure)

proc radula_behave_generate_initramfs*(bootstrap: bool = false, directory: string) =
  discard execCmd(&"{RADULA_CERAS_BOOSTER} build --force --compression={RADULA_CERAS_ZSTD} --config={RADULA_PATH_RADULA_CLUSTERS_GLAUCUS / RADULA_CERAS_BOOSTER / RADULA_FILE_BOOSTER_CONF} {(if bootstrap: \"--universal\" else: \"\")} --strip {directory / RADULA_FILE_INITRAMFS_GLAUCUS}")

proc radula_behave_lock*() =
  if fileExists(RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_FILE_RADULA_LOCK):
    styled_echo fg_red, style_bright, &"{\"Abort\":13} :! {\"lock exists\":48}{\"1\":13}{now().format(\"hh:mm:ss tt\")}", reset_style

    quit(QuitFailure)
  else:
    writeFile(RADULA_PATH_PKG_CONFIG_SYSROOT_DIR / RADULA_DIRECTORY_TEMPORARY / RADULA_FILE_RADULA_LOCK, "")

proc radula_behave_rsync*(source, destination, flags: string = RADULA_TOOTH_RSYNC_FLAGS): int =
  execCmd(&"{RADULA_CERAS_RSYNC} {flags} {source} {destination} --delete {RADULA_TOOTH_SHELL_REDIRECTION}")

proc radula_behave_teeth_environment*() =
  putEnv(RADULA_ENVIRONMENT_TOOTH_AUTORECONF, RADULA_TOOTH_AUTORECONF & ' ' & RADULA_TOOTH_AUTORECONF_FLAGS)
  # `mawk` is the default awk implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_AWK, RADULA_CERAS_MAWK)
  # `byacc` is the default yacc implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_BISON, RADULA_CERAS_BYACC)
  putEnv(RADULA_ENVIRONMENT_TOOTH_CHMOD, RADULA_TOOTH_CHMOD & ' ' & RADULA_TOOTH_CHMOD_CHOWN_FLAGS)
  putEnv(RADULA_ENVIRONMENT_TOOTH_CHOWN, RADULA_TOOTH_CHOWN & ' ' & RADULA_TOOTH_CHMOD_CHOWN_FLAGS)
  # `flex` is the default lex implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_FLEX, RADULA_CERAS_FLEX)
  # `mawk` is the default awk implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_GAWK, RADULA_CERAS_MAWK)
  # `flex` is the default lex implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_LEX, RADULA_CERAS_FLEX)
  putEnv(RADULA_ENVIRONMENT_TOOTH_LN, RADULA_TOOTH_LN & ' ' & RADULA_TOOTH_LN_FLAGS)
  # `make` and its flags
  putEnv(RADULA_ENVIRONMENT_TOOTH_MAKE, RADULA_CERAS_MAKE)
  putEnv(RADULA_ENVIRONMENT_TOOTH_MAKEFLAGS, RADULA_TOOTH_MAKEFLAGS)
  putEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR, RADULA_TOOTH_MKDIR & ' ' & RADULA_TOOTH_MKDIR_FLAGS)
  putEnv(RADULA_ENVIRONMENT_TOOTH_MKDIR_P, RADULA_TOOTH_MKDIR & ' ' & RADULA_TOOTH_MKDIR_FLAGS)
  putEnv(RADULA_ENVIRONMENT_TOOTH_MV, RADULA_TOOTH_MV & ' ' & RADULA_TOOTH_MV_FLAGS)
  putEnv(RADULA_ENVIRONMENT_TOOTH_PATCH, RADULA_CERAS_PATCH & ' ' & RADULA_TOOTH_PATCH_FLAGS)
  # `pkgconf` is the default pkg-config implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_PKG_CONFIG, RADULA_CERAS_PKGCONF)
  putEnv(RADULA_ENVIRONMENT_TOOTH_RM, RADULA_TOOTH_RM & ' ' & RADULA_TOOTH_RM_FLAGS)
  putEnv(RADULA_ENVIRONMENT_TOOTH_RSYNC, RADULA_CERAS_RSYNC & ' ' & RADULA_TOOTH_RSYNC_FLAGS)
  # `byacc` is the default yacc implementation
  putEnv(RADULA_ENVIRONMENT_TOOTH_YACC, RADULA_CERAS_BYACC)
