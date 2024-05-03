# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  constants

proc rad_genome_flags_env*() =
  putEnv(RAD_ENV_FLAGS_CFLAGS, RAD_FLAGS_CFLAGS)
  putEnv(RAD_ENV_FLAGS_CXXFLAGS, RAD_FLAGS_CFLAGS)
  putEnv(RAD_ENV_FLAGS_LDFLAGS, RAD_FLAGS_LDFLAGS & ' ' & RAD_FLAGS_CFLAGS)

# Return the canonical system tuple from `config.guess`
proc rad_genome_tuple*(): (string, int) =
  execCmdEx(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / RAD_CERAS_BINUTILS / RAD_FILE_CONFIG_GUESS)

proc rad_genome_env*(stage = RAD_DIR_CROSS) =
  putEnv(RAD_ENV_GENOME_ARCH, RAD_GENOME_X86_64)
  putEnv(RAD_ENV_GENOME_CARCH, RAD_GENOME_X86_64_V3)
  putEnv(RAD_ENV_GENOME_PRETTY_NAME, &"{RAD_DIR_GLAUCUS} {RAD_CERAS_S6} {RAD_GENOME_X86_64_V3} {now().format(\"YYYYMMdd\")}")

  putEnv(RAD_ENV_TUPLE_BLD, rad_genome_tuple()[0].strip())
  putEnv(RAD_ENV_TUPLE_TGT, RAD_GENOME_X86_64_LINUX & (if stage == RAD_DIR_CROSS: RAD_GENOME_TUPLE_TGT_CROSS else: RAD_GENOME_TUPLE_TGT_SYSTEM))
