# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, sequtils, strformat, strutils, tables, terminal, times],
  constants, tools,
  hashlib/misc/blake3, toml_serialization, toposort

type
  Ceras = object
    nom, ver, cmt, url, sum, bld, run = $NIL

# Check if the `ceras` src is extracted
proc rad_ceras_check_extract_src(file: string): bool =
  walkDir(parentDir(file)).toSeq().len() > 1

proc rad_ceras_clean*() =
  removeDir($RAD_LOG)
  removeDir($RAD_TMP)

proc rad_ceras_distclean*() =
  removeDir($RAD_CACHE_BIN)
  removeDir($RAD_CACHE_SRC)
  removeDir($RAD_CACHE_VENOM)

  rad_ceras_clean()

# Return the full path to the `ceras` file
proc rad_ceras_path(nom: string): string =
  $RAD_LIB_CLUSTERS_GLAUCUS / nom / $ceras

# Check if the `ceras` file exists
proc rad_ceras_check_exist(nom: string) =
  if not fileExists(rad_ceras_path(nom)):
    rad_abort(&"""{"nom":8}{nom:48}""")

# Parse the `ceras` file
proc rad_ceras_parse(nom: string): Ceras =
  Toml.loadFile(rad_ceras_path(nom), Ceras)

proc rad_ceras_print*(cerata: openArray[string]) =
  for nom in cerata.deduplicate():
    rad_ceras_check_exist(nom)

    let ceras = rad_ceras_parse(nom)

    echo "nom  :: ", ceras.nom
    echo "ver  :: ", ceras.ver
    echo "cmt  :: ", ceras.cmt
    echo "url  :: ", ceras.url
    echo "sum  :: ", ceras.sum
    echo "bld  :: ", ceras.bld
    echo "run  :: ", ceras.run

    echo ""

proc rad_ceras_print_content(idx: int, nom, ver, cmd: string) =
  styledEcho fgMagenta, styleBright, &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}""", resetStyle

proc rad_ceras_print_footer(idx: int, nom, ver, cmd: string) =
  echo &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc rad_ceras_print_header() =
  echo &"""{"idx":8}{"nom":24}{"ver":24}{"cmd":8}fin"""

# Resolve deps using topological sorting
proc rad_ceras_resolve_deps(nom: string, deps: var Table[string, seq[string]], run = true) =
  let
    ceras = rad_ceras_parse(nom)
    dep = if run: ceras.run else: ceras.bld

  deps[ceras.nom] =
    case dep
    of $NIL:
      @[]
    else:
      ceras.run.split()

  if deps[ceras.nom].len() > 0:
    for dep in deps[ceras.nom]:
      rad_ceras_resolve_deps(dep, deps, if run: true else: false)

proc rad_ceras_check*(cerata: openArray[string], run = true): seq[string] =
  var deps: Table[string, seq[string]]

  for nom in cerata.deduplicate():
    rad_ceras_check_exist(nom)

    rad_ceras_resolve_deps(nom, deps, if run: true else: false)

  topoSort(deps)

proc rad_ceras_fetch(cerata: openArray[string]) =
  rad_ceras_print_header()

  for idx, nom in cerata:
    let ceras = rad_ceras_parse(nom)

    # Check for virtual cerata
    case ceras.url
    of $NIL:
      rad_ceras_print_footer(idx, ceras.nom, ceras.ver, $fetch)
    else:
      let
        path = getEnv($SRCD) / ceras.nom
        archive = path / lastPathPart(ceras.url)

      if dirExists(path):
        case ceras.ver
        of $git:
          rad_ceras_print_footer(idx, ceras.nom, ceras.cmt, $fetch)
        else:
          if rad_verify_file(archive, ceras.sum):
            if not rad_ceras_check_extract_src(archive):
              rad_ceras_print_content(idx, ceras.nom, ceras.ver, $fetch)

              discard rad_extract_tar(archive, path)

              cursorUp 1
              eraseLine()

            rad_ceras_print_footer(idx, ceras.nom, ceras.ver, $fetch)
          else:
            rad_ceras_print_content(idx, ceras.nom, ceras.ver, $fetch)

            removeDir(path)
            createDir(path)

            discard rad_download_file(archive, ceras.url)

            if rad_verify_file(archive, ceras.sum):
              discard rad_extract_tar(archive, path)
            else:
              cursorUp 1
              eraseLine()

              rad_abort(&"""{"sum":8}{ceras.nom:24}{ceras.ver:24}""")

            cursorUp 1
            eraseLine()

            rad_ceras_print_footer(idx, ceras.nom, ceras.ver, $fetch)
      else:
        case ceras.ver
        of $git:
          rad_ceras_print_content(idx, ceras.nom, ceras.cmt, $clone)

          discard rad_clone_repo(ceras.url, path)
          discard rad_checkout_repo(path, ceras.cmt)

          cursorUp 1
          eraseLine()

          rad_ceras_print_footer(idx, ceras.nom, ceras.cmt, $clone)
        else:
          rad_ceras_print_content(idx, ceras.nom, ceras.ver, $fetch)

          createDir(path)

          discard rad_download_file(archive, ceras.url)

          if rad_verify_file(archive, ceras.sum):
            discard rad_extract_tar(archive, path)
          else:
            cursorUp 1
            eraseLine()

            rad_abort(&"""{"sum":8}{ceras.nom:24}{ceras.ver:24}""")

          cursorUp 1
          eraseLine()

          rad_ceras_print_footer(idx, ceras.nom, ceras.ver, $fetch)

proc rad_ceras_build*(cerata: openArray[string], stage = $native, resolve = true) =
  let cluster = rad_ceras_check(cerata, false)

  rad_ceras_fetch(cluster)

  echo ""

  rad_ceras_print_header()

  for idx, nom in (if resolve: cluster else: cerata.toSeq()):
    let
      ceras = rad_ceras_parse(nom)

      log = getEnv($LOGD) / &"{ceras.nom}{CurDir}{log}"

    rad_ceras_print_content(idx, ceras.nom,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $build)

    case stage
    of $native:
      if fileExists($RAD_CACHE_VENOM / ceras.nom / &"""{ceras.nom}{(
        case ceras.url
        of $NIL:
          ""
        else:
          '-' & ceras.ver
      )}{(
        case ceras.ver
        of $git:
          '-' & ceras.cmt
        else:
          ""
      )}{tar_zst}"""):
        cursorUp 1
        eraseLine()

        rad_ceras_print_footer(idx, ceras.nom,
          case ceras.ver
          of $git:
            ceras.cmt
          else:
            ceras.ver
        , $build)

        continue

      putEnv($SACD, $RAD_CACHE_VENOM / ceras.nom / $sac)
      createDir(getEnv($SACD))

    # We only use `nom` and `ver` from `ceras`
    #
    # All phases need to be called sequentially to prevent the loss of the
    # current working dir...
    var status = execCmd(&"""
      {sh} {SHELL_COMMAND} 'nom={ceras.nom} ver={ceras.ver} {CurDir} {RAD_LIB_CLUSTERS_GLAUCUS}{DirSep}{ceras.nom}{DirSep}{build}{CurDir}{stage} &&
      ceras_prepare $1 &&
      ceras_configure $1 &&
      ceras_build $1 &&
      ceras_check $1 &&
      ceras_install $1'
    """ % &">> {log} 2>&1")

    cursorUp 1
    eraseLine()

    if status != 0:
      rad_abort(&"""{status:<8}{ceras.nom:24}{(
        case ceras.ver
        of $git:
          ceras.cmt
        else:
          ceras.ver
      ):24}""")

    case stage
    of $native:
      status = rad_create_tar_zst($RAD_CACHE_VENOM / ceras.nom / &"""{ceras.nom}{(
        case ceras.url
        of $NIL:
          ""
        else:
          '-' & ceras.ver
      )}{(
        case ceras.ver
        of $git:
          '-' & ceras.cmt
        else:
          ""
      )}{tar_zst}""", getEnv($SACD))

      if status == 0:
        rad_gen_sum(getEnv($SACD), $RAD_CACHE_VENOM / ceras.nom / $sum)

        removeDir(getEnv($SACD))

    rad_ceras_print_footer(idx, ceras.nom,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $build)

proc rad_ceras_install*(cerata: openArray[string]) =
  let cluster = rad_ceras_check(cerata)

  rad_ceras_print_header()

  for idx, nom in cluster:
    let ceras = rad_ceras_parse(nom)

    rad_ceras_print_content(idx, ceras.nom,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $install)

    let status = rad_extract_tar($RAD_CACHE_VENOM / ceras.nom / &"""{ceras.nom}{(
      case ceras.url
      of $NIL:
        ""
      else:
        '-' & ceras.ver
    )}{(
      case ceras.ver
      of $git:
        '-' & ceras.cmt
      else:
        ""
    )}{tar_zst}""", $DirSep)

    cursorUp 1
    eraseLine()

    if status != 0:
      rad_abort(&"""{status:<8}{ceras.nom:24}{(
        case ceras.ver
        of $git:
          ceras.cmt
        else:
          ceras.ver
      ):24}""")

    rad_ceras_print_footer(idx, ceras.nom,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $install)

proc rad_ceras_remove*(cerata: openArray[string]) =
  let cluster = rad_ceras_check(cerata)

  rad_ceras_print_header()

  for idx, nom in cluster:
    let ceras = rad_ceras_parse(nom)

    rad_ceras_print_content(idx, ceras.nom,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $remove)

    let sum = $RAD_CACHE_VENOM / ceras.nom / $sum

    for line in lines(sum):
      removeFile(DirSep & line.split()[2])

    cursorUp 1
    eraseLine()

    rad_ceras_print_footer(idx, ceras.nom,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $remove)

proc rad_ceras_search*(pattern: openArray[string]) =
  var cerata: seq[string]

  for file in walkDir($RAD_LIB_CLUSTERS_GLAUCUS, relative = true, skipSpecial = true):
    for nom in pattern:
      if nom.toLowerAscii() in file[1]:
        cerata.add(file[1])

  sort(cerata)

  rad_ceras_print(cerata)
