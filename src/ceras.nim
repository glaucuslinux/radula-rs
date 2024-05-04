# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, sequtils, strformat, strutils, tables, terminal, times],
  constants, teeth,
  hashlib/misc/blake3, toml_serialization, toposort

type
  Ceras = object
    nom, ver, cmt, url, sum, bld, run: string = RAD_PRINT_NIL

proc rad_ceras_clean*() =
  removeDir(RAD_PATH_RAD_LOG)
  removeDir(RAD_PATH_RAD_TMP)

proc rad_ceras_distclean*() =
  removeDir(RAD_PATH_RAD_CACHE_BIN)
  removeDir(RAD_PATH_RAD_CACHE_SRC)
  removeDir(RAD_PATH_RAD_CACHE_VENOM)

  rad_ceras_clean()

# Check if the `ceras` src is extracted
proc rad_ceras_extract_src(file: string): bool =
  toSeq(walkDir(parentDir(file))).len > 1

# Return the full path to the `ceras` file
func rad_ceras_path(nom: string): string =
  RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS / nom / RAD_FILE_CERAS

# Check if the full path to the `ceras` file exists
proc rad_ceras_exist(nom: string) =
  if not fileExists(rad_ceras_path(nom)):
    rad_abort(&"{\"nom\":8}{nom:48}")

# Parse the `ceras` file
proc rad_ceras_parse(nom: string): Ceras =
  Toml.loadFile(rad_ceras_path(nom), Ceras)

proc rad_ceras_print*(cerata: openArray[string]) =
  for nom in cerata.deduplicate():
    rad_ceras_exist(nom)

    let ceras = rad_ceras_parse(nom)

    echo "nom  :: ", ceras.nom
    echo "ver  :: ", ceras.ver
    echo "cmt  :: ", ceras.cmt
    echo "url  :: ", ceras.url
    echo "sum  :: ", ceras.sum
    echo "bld  :: ", ceras.bld
    echo "run  :: ", ceras.run

    echo ""

proc rad_ceras_print_content(idx: int, nom, ver, status: string) =
  styledEcho fgMagenta, styleBright, &"{idx + 1:<8}{nom:24}{ver:24}{status:8}{now().format(\"hh:mm tt\")}", resetStyle

proc rad_ceras_print_footer(idx: int, nom, ver, status: string) =
  styledEcho fgGreen, &"{idx + 1:<8}", resetStyle, &"{nom:24}{ver:24}", fgGreen, &"{status:8}", fgYellow, now().format("hh:mm tt"), fgDefault

proc rad_ceras_print_header() =
  styledEcho styleBright, '-'.repeat(72), resetStyle
  styledEcho styleBright, &"{\"idx\":8}{\"nom\":24}{\"ver\":24}{\"cmd\":8}eta", resetStyle
  styledEcho styleBright, '-'.repeat(72), resetStyle

# Resolve deps using topological sorting
proc rad_ceras_resolve_deps(nom: string, deps: var Table[string, seq[string]], run = true) =
  let ceras = rad_ceras_parse(nom)

  deps[ceras.nom] = if run: ceras.run.split() else: ceras.bld.split()

  if deps[nom].len() > 0:
    for dep in deps[nom]:
      rad_ceras_resolve_deps(dep, deps, if run: true else: false)

proc rad_ceras_check*(cerata: openArray[string], run = true): seq[string] =
  var deps: Table[string, seq[string]]

  for nom in cerata.deduplicate():
    rad_ceras_exist(nom)

    rad_ceras_resolve_deps(nom, deps, if run: true else: false)

  topoSort(deps)

func rad_ceras_stage(log, nom, ver: string, stage = RAD_DIR_SYSTEM): int =
  # We only use `nom` and `ver` from `ceras`
  #
  # All phases need to be called sequentially to prevent the loss of the
  # current working directory...
  execCmd(&"{RAD_TOOTH_SHELL} {RAD_FLAGS_TOOTH_SHELL_COMMAND} 'nom={nom} ver={ver} . {RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS}/{nom}/{stage} && ceras_prepare $1 && ceras_configure $1 && ceras_build $1 && ceras_check $1 && ceras_install $1'" % &">> {log} 2>&1")

# Fetch cerata
proc rad_ceras_fetch(cerata: openArray[string]) =
  var
    clones: seq[(array[3, string], string)]
    downloads: seq[(array[5, string], string)]

    counter: int

  for idx, nom in cerata:
    let
      ceras = rad_ceras_parse(nom)

    # Check for virtual cerata
    if ceras.url.isEmptyOrWhitespace():
      rad_ceras_print_footer(idx, ceras.nom, ceras.ver, RAD_PRINT_FETCH)

      continue

    let
      path = getEnv(RAD_ENV_DIR_SRCD) / ceras.nom
      archive = path / lastPathPart(ceras.url)

    if dirExists(path):
      if ceras.ver == RAD_TOOTH_GIT:
        rad_ceras_print_footer(idx, ceras.nom, ceras.ver, RAD_PRINT_FETCH)
      else:
        if rad_verify_file(archive, ceras.sum):
          if not rad_ceras_extract_src(archive):
            rad_ceras_print_content(idx, ceras.nom, ceras.ver, RAD_PRINT_FETCH)

            discard rad_extract_tar(archive, path)

            cursorUp 1
            eraseLine()

          rad_ceras_print_footer(idx, ceras.nom, ceras.ver, RAD_PRINT_FETCH)
        else:
          removeDir(path)

          downloads &= ([ceras.nom, ceras.ver, ceras.sum, path, archive], &"{RAD_CERAS_WGET2} -q -O {archive} -c -N {ceras.url}")
    else:
      if ceras.ver == RAD_TOOTH_GIT:
        clones &= ([ceras.nom, ceras.cmt, path], &"{RAD_TOOTH_GIT} {RAD_FLAGS_TOOTH_GIT_CLONE} {ceras.url} {path} -q && {RAD_TOOTH_GIT} -C {path} {RAD_FLAGS_TOOTH_GIT_CHECKOUT} {ceras.cmt} -q")
      else:
        downloads &= ([ceras.nom, ceras.ver, ceras.sum, path, archive], &"{RAD_CERAS_WGET2} -q -O {archive} -c -N {ceras.url}")

  var length = downloads.len()

  if length > 0:
    echo ""

    rad_ceras_print_header()

    let cluster = downloads.unzip()[0]

    discard execProcesses(downloads.unzip()[1], n = 5, beforeRunEvent =
      proc (idx: int) =
        let
          ceras = cluster[idx]

          nom = ceras[0]
          ver = ceras[1]

          path = ceras[3]

        rad_ceras_print_content(idx, nom, ver, RAD_PRINT_DOWNLOAD)

        createDir(path)

        counter += 1
    , afterRunEvent =
      proc (idx: int; p: Process) =
        let
          ceras = cluster[idx]

          nom = ceras[0]
          ver = ceras[1]
          sum = ceras[2]

          path = ceras[3]
          archive = ceras[4]

        if rad_verify_file(archive, sum):
          discard rad_extract_tar(archive, path)
        else:
          cursorUp 1
          eraseLine()

          rad_abort(&"{\"sum\":8}{nom:24}{ver:24}")

        cursorUp 1
        eraseLine()

        rad_ceras_print_footer(idx, nom, ver, RAD_PRINT_DOWNLOAD)

        cursorDown counter - idx
    )

  counter = 0

  length = clones.len()

  if length > 0:
    echo ""

    rad_ceras_print_header()

    let cluster = clones.unzip()[0]

    discard execProcesses(clones.unzip()[1], n = 5, beforeRunEvent =
      proc (idx: int) =
        let
          ceras = cluster[idx]

          nom = ceras[0]
          cmt = ceras[1]

        rad_ceras_print_content(idx, nom, cmt, RAD_PRINT_CLONE)

        counter += 1
    , afterRunEvent =
      proc (idx: int; p: Process) =
        let
          ceras = cluster[idx]

          nom = ceras[0]
          cmt = ceras[1]

        cursorUp counter - idx
        eraseLine()

        rad_ceras_print_footer(idx, nom, cmt, RAD_PRINT_CLONE)

        cursorDown counter - idx
    )

proc rad_ceras_build*(cerata: openArray[string], stage = RAD_DIR_SYSTEM, resolve = true) =
  let cluster = rad_ceras_check(cerata, false)

  rad_ceras_print_header()

  # Fetch cluster in parallel
  rad_ceras_fetch(cluster)

  echo ""

  rad_ceras_print_header()

  for idx, nom in (if resolve: cluster else: cerata.toSeq()):
    let ceras = rad_ceras_parse(nom)

    rad_ceras_print_content(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_BUILD)

    let log = getEnv(RAD_ENV_DIR_LOGD) / ceras.nom & CurDir & RAD_DIR_LOG

    if stage == RAD_DIR_SYSTEM:
      if fileExists(RAD_PATH_RAD_CACHE_VENOM / ceras.nom / &"{ceras.nom}{(if not ceras.url.isEmptyOrWhitespace(): '-' & ceras.ver else: \"\")}{(if ceras.ver == RAD_TOOTH_GIT: '-' & ceras.cmt else: \"\")}{RAD_FILE_TAR_ZST}"):
        cursorUp 1
        eraseLine()

        rad_ceras_print_footer(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_BUILD)

        continue

      putEnv(RAD_ENV_DIR_SACD, RAD_PATH_RAD_CACHE_VENOM / ceras.nom / RAD_DIR_SAC)
      createDir(getEnv(RAD_ENV_DIR_SACD))

    var status = rad_ceras_stage(log, ceras.nom, ceras.ver, stage)

    cursorUp 1
    eraseLine()

    if status != 0:
      rad_abort(&"{status:<8}{ceras.nom:24}{(if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver):24}")

    if stage == RAD_DIR_SYSTEM:
      status = rad_create_tar_zst(RAD_PATH_RAD_CACHE_VENOM / ceras.nom / &"{ceras.nom}{(if not ceras.url.isEmptyOrWhitespace(): '-' & ceras.ver else: \"\")}{(if ceras.ver == RAD_TOOTH_GIT: '-' & ceras.cmt else: \"\")}{RAD_FILE_TAR_ZST}", getEnv(RAD_ENV_DIR_SACD))

      if status == 0:
        rad_gen_sum(getEnv(RAD_ENV_DIR_SACD), RAD_PATH_RAD_CACHE_VENOM / nom / RAD_FILE_SUM)

        removeDir(getEnv(RAD_ENV_DIR_SACD))

    rad_ceras_print_footer(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_BUILD)

proc rad_ceras_install*(cerata: openArray[string]) =
  let cluster = rad_ceras_check(cerata)

  rad_ceras_print_header()

  for idx, nom in cluster:
    let ceras = rad_ceras_parse(nom)

    rad_ceras_print_content(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_INSTALL)

    let status = rad_extract_tar(RAD_PATH_RAD_CACHE_VENOM / ceras.nom / &"{ceras.nom}{(if not ceras.url.isEmptyOrWhitespace(): '-' & ceras.ver else: \"\")}{(if ceras.ver == RAD_TOOTH_GIT: '-' & ceras.cmt else: \"\")}{RAD_FILE_TAR_ZST}", RAD_PATH_PKG_CONFIG_SYSROOT_DIR)

    cursorUp 1
    eraseLine()

    if status != 0:
      rad_abort(&"{status:8}{ceras.nom:24}{(if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver):24}")

    rad_ceras_print_footer(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_INSTALL)

proc rad_ceras_remove*(cerata: openArray[string]) =
  let cluster = rad_ceras_check(cerata)

  rad_ceras_print_header()

  for idx, nom in cluster:
    let ceras = rad_ceras_parse(nom)

    rad_ceras_print_content(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_REMOVE)

    let sum = RAD_PATH_RAD_CACHE_VENOM / ceras.nom / RAD_FILE_SUM

    for line in lines(sum):
      removeFile(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / line.split()[2])

    cursorUp 1
    eraseLine()

    rad_ceras_print_footer(idx, ceras.nom, if ceras.ver == RAD_TOOTH_GIT: ceras.cmt else: ceras.ver, RAD_PRINT_REMOVE)

proc rad_ceras_search*(pattern: openArray[string]) =
  var cerata: seq[string]

  for file in walkDir(RAD_PATH_RAD_LIB_CLUSTERS_GLAUCUS, relative = true, skipSpecial = true):
    for nom in pattern:
      if nom.toLowerAscii() in file[1]:
        cerata.add(file[1])

  sort(cerata)

  rad_ceras_print(cerata)
