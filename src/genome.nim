# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  osproc,
  strformat,
  strutils,
  times
]

import constants

proc radula_genome_flags_environment*() =
  putEnv(RADULA_ENVIRONMENT_FLAGS_C_COMPILER, RADULA_FLAGS_C_CXX_COMPILER)
  putEnv(RADULA_ENVIRONMENT_FLAGS_CXX_COMPILER, RADULA_FLAGS_C_CXX_COMPILER)
  putEnv(RADULA_ENVIRONMENT_FLAGS_LINKER, RADULA_FLAGS_LINKER & ' ' & RADULA_FLAGS_C_CXX_COMPILER)

# Return the canonical system tuple from `config.guess`
proc radula_genome_tuple*(): (string, int) =
  execCmdEx(RADULA_PATH_RADULA_CLUSTERS_GLAUCUS / RADULA_CERAS_BINUTILS / RADULA_FILE_CONFIG_GUESS)

proc radula_genome_environment*(stage = RADULA_DIRECTORY_CROSS) =
  putEnv(RADULA_ENVIRONMENT_GENOME, RADULA_GENOME_X86_64)
  putEnv(RADULA_ENVIRONMENT_GENOME_CERATA, RADULA_GENOME_X86_64_V3)
  putEnv(RADULA_ENVIRONMENT_GENOME_PRETTY_NAME, &"{RADULA_DIRECTORY_GLAUCUS} {RADULA_CERAS_S6} {RADULA_GENOME_X86_64_V3} {now().format(\"YYYYMMdd\")}")

  putEnv(RADULA_ENVIRONMENT_TUPLE_BUILD, radula_genome_tuple()[0].strip())
  putEnv(RADULA_ENVIRONMENT_TUPLE_TARGET, RADULA_GENOME_X86_64_LINUX & (if stage == RADULA_DIRECTORY_CROSS: RADULA_GENOME_TUPLE_TARGET_CROSS else: RADULA_GENOME_TUPLE_TARGET_SYSTEM))
