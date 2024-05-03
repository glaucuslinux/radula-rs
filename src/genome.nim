# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, osproc, strformat, strutils, times],
  constants

proc rad_genome_flags_environment*() =
  putEnv(RAD_ENVIRONMENT_FLAGS_C_COMPILER, RAD_FLAGS_C_CXX_COMPILER)
  putEnv(RAD_ENVIRONMENT_FLAGS_CXX_COMPILER, RAD_FLAGS_C_CXX_COMPILER)
  putEnv(RAD_ENVIRONMENT_FLAGS_LINKER, RAD_FLAGS_LINKER & ' ' & RAD_FLAGS_C_CXX_COMPILER)

# Return the canonical system tuple from `config.guess`
proc rad_genome_tuple*(): (string, int) =
  execCmdEx(RAD_PATH_RAD_LIBRARY_CLUSTERS_GLAUCUS / RAD_CERAS_BINUTILS / RAD_FILE_CONFIG_GUESS)

proc rad_genome_environment*(stage = RAD_DIRECTORY_CROSS) =
  putEnv(RAD_ENVIRONMENT_GENOME, RAD_GENOME_X86_64)
  putEnv(RAD_ENVIRONMENT_GENOME_CERATA, RAD_GENOME_X86_64_V3)
  putEnv(RAD_ENVIRONMENT_GENOME_PRETTY_NAME, &"{RAD_DIRECTORY_GLAUCUS} {RAD_CERAS_S6} {RAD_GENOME_X86_64_V3} {now().format(\"YYYYMMdd\")}")

  putEnv(RAD_ENVIRONMENT_TUPLE_BUILD, rad_genome_tuple()[0].strip())
  putEnv(RAD_ENVIRONMENT_TUPLE_TARGET, RAD_GENOME_X86_64_LINUX & (if stage == RAD_DIRECTORY_CROSS: RAD_GENOME_TUPLE_TARGET_CROSS else: RAD_GENOME_TUPLE_TARGET_SYSTEM))
