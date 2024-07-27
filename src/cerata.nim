# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, sequtils, strformat, strutils, tables, terminal, times],
  constants, tools,
  hashlib/misc/blake3, toml_serialization, toposort

type
  Ceras = object
    nom, ver, cmt, url, sum, bld, run = $Nil

func `$` (ceras: Ceras): string =
  ceras.nom

# Check if the `ceras` src is extracted
proc checkExtractSrc(file: string): bool =
  walkDir(parentDir(file)).toSeq().len() > 1

proc cleanCerata*() =
  removeDir($radLog)
  removeDir($radTmp)

proc distcleanCerata*() =
  removeDir($radCacheLocal)
  removeDir($radCachePkg)
  removeDir($radCacheSrc)

  cleanCerata()

# Return the full path to the `ceras` file
proc getCerasPath(nom: string): string =
  $radLibClustersCerata / nom / $ceras

# Check if the `ceras` file exists
proc checkCerasExist(nom: string) =
  if not fileExists(getCerasPath(nom)):
    abort(&"""{"nom":8}{nom:48}""")

# Parse the `ceras` file
proc parseCeras*(nom: string): Ceras =
  Toml.loadFile(getCerasPath(nom), Ceras)

proc printCerata*(cerata: openArray[string]) =
  for nom in cerata.deduplicate():
    checkCerasExist(nom)

    let ceras = parseCeras(nom)

    echo &"nom  :: {ceras}"
    echo &"ver  :: {ceras.ver}"
    echo &"cmt  :: {ceras.cmt}"
    echo &"url  :: {ceras.url}"
    echo &"sum  :: {ceras.sum}"
    echo &"bld  :: {ceras.bld}"
    echo &"run  :: {ceras.run}"

    echo ""

proc printContent(idx: int, nom, ver, cmd: string) =
  styledEcho fgMagenta, styleBright, &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc printFooter(idx: int, nom, ver, cmd: string) =
  echo &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc printHeader() =
  echo &"""{"idx":8}{"nom":24}{"ver":24}{"cmd":8}fin"""
  echo '~'.repeat(72)

# Resolve deps using topological sorting
proc resolveDeps(nom: string, deps: var Table[string, seq[string]], run = true) =
  let
    ceras = parseCeras(nom)
    dep = if run: ceras.run else: ceras.bld

  deps[$ceras] =
    case dep
    of $Nil:
      @[]
    else:
      dep.split()

  if deps[$ceras].len() > 0:
    for dep in deps[$ceras]:
      resolveDeps(dep, deps, if run: true else: false)

proc checkCerata*(cerata: openArray[string], run = true): seq[string] =
  var deps: Table[string, seq[string]]

  for nom in cerata.deduplicate():
    checkCerasExist(nom)

    resolveDeps(nom, deps, if run: true else: false)

  topoSort(deps)

proc fetchCerata(cerata: openArray[string]) =
  printHeader()

  for idx, nom in cerata:
    let ceras = parseCeras(nom)

    # Check for virtual cerata
    case ceras.url
    of $Nil:
      printFooter(idx, $ceras, ceras.ver, $fetch)
    else:
      let
        path = getEnv($SRCD) / $ceras
        archive = path / lastPathPart(ceras.url)

      if dirExists(path):
        case ceras.ver
        of $git:
          printFooter(idx, $ceras, ceras.cmt, $fetch)
        else:
          if verifyFile(archive, ceras.sum):
            if not checkExtractSrc(archive):
              printContent(idx, $ceras, ceras.ver, $fetch)

              discard extractTar(archive, path)

              cursorUp 1
              eraseLine()

            printFooter(idx, $ceras, ceras.ver, $fetch)
          else:
            printContent(idx, $ceras, ceras.ver, $fetch)

            removeDir(path)
            createDir(path)

            discard downloadFile(archive, ceras.url)

            if verifyFile(archive, ceras.sum):
              discard extractTar(archive, path)
            else:
              cursorUp 1
              eraseLine()

              abort(&"""{"sum":8}{ceras:24}{ceras.ver:24}""")

            cursorUp 1
            eraseLine()

            printFooter(idx, $ceras, ceras.ver, $fetch)
      else:
        case ceras.ver
        of $git:
          printContent(idx, $ceras, ceras.cmt, $clone)

          discard gitCloneRepo(ceras.url, path)
          discard gitCheckoutRepo(path, ceras.cmt)

          cursorUp 1
          eraseLine()

          printFooter(idx, $ceras, ceras.cmt, $clone)
        else:
          printContent(idx, $ceras, ceras.ver, $fetch)

          createDir(path)

          discard downloadFile(archive, ceras.url)

          if verifyFile(archive, ceras.sum):
            discard extractTar(archive, path)
          else:
            cursorUp 1
            eraseLine()

            abort(&"""{"sum":8}{ceras:24}{ceras.ver:24}""")

          cursorUp 1
          eraseLine()

          printFooter(idx, $ceras, ceras.ver, $fetch)

proc buildCerata*(cerata: openArray[string], stage = $native, resolve = true) =
  let cluster = checkCerata(cerata, false)

  fetchCerata(cluster)

  echo ""

  printHeader()

  for idx, nom in (if resolve: cluster else: cerata.toSeq()):
    let ceras = parseCeras(nom)

    printContent(idx, $ceras,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $build)

    case stage
    of $native:
      if fileExists($radCacheLocal / $ceras / &"""{ceras}{(
        case ceras.url
        of $Nil:
          ""
        else:
          '-' & ceras.ver
      )}{(
        case ceras.ver
        of $git:
          '-' & ceras.cmt
        else:
          ""
      )}{tarZst}"""):
        cursorUp 1
        eraseLine()

        printFooter(idx, $ceras,
          case ceras.ver
          of $git:
            ceras.cmt
          else:
            ceras.ver
        , $build)

        continue

      putEnv($SACD, $radCacheLocal / $ceras / $sac)
      createDir(getEnv($SACD))

    # We only use `nom` and `ver` from `ceras`
    #
    # All phases need to be called sequentially to prevent the loss of the
    # current working dir...
    var status = execCmd(&"""
      {sh} {shellCommand} 'nom={ceras} ver={ceras.ver} {CurDir} {$radLibClustersCerata / $ceras / $build}{CurDir}{stage} &&
      prepare $1 &&
      configure $1 &&
      build $1 &&
      check $1 &&
      package $1'
    """ % &">> {getEnv($LOGD) / $ceras}{CurDir}{log} 2>&1")

    if status != 0:
      abort(&"""{status:<8}{ceras:24}{(
        case ceras.ver
        of $git:
          ceras.cmt
        else:
          ceras.ver
      ):24}""")

    case stage
    of $native:
      status = createTarZst($radCacheLocal / $ceras / &"""{ceras}{(
        case ceras.url
        of $Nil:
          ""
        else:
          '-' & ceras.ver
      )}{(
        case ceras.ver
        of $git:
          '-' & ceras.cmt
        else:
          ""
      )}{tarZst}""", getEnv($SACD))

      if status == 0:
        genSum(getEnv($SACD), $radCacheLocal / $ceras / $sum)

        removeDir(getEnv($SACD))

    cursorUp 1
    eraseLine()

    printFooter(idx, $ceras,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $build)

proc installCerata*(cerata: openArray[string], cache = $radCacheLocal, fs = $DirSep, lib = $radLibLocal) =
  let cluster = checkCerata(cerata)

  printHeader()

  for idx, nom in cluster:
    let ceras = parseCeras(nom)

    printContent(idx, $ceras,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $install)

    let status = extractTar(cache / $ceras / &"""{ceras}{(
      case ceras.url
      of $Nil:
        ""
      else:
        '-' & ceras.ver
    )}{(
      case ceras.ver
      of $git:
        '-' & ceras.cmt
      else:
        ""
    )}{tarZst}""", fs)

    if status != 0:
      abort(&"""{status:<8}{ceras:24}{(
        case ceras.ver
        of $git:
          ceras.cmt
        else:
          ceras.ver
      ):24}""")

    createDir(lib / $ceras)

    writeFile(lib / $ceras / "ver", ceras.ver)

    discard rsync(cache / $ceras / $sum, lib / $ceras)

    cursorUp 1
    eraseLine()

    printFooter(idx, $ceras,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $install)

proc listCerata*() =
  printCerata(walkDir($radLibLocal, true, skipSpecial = true).toSeq().unzip()[1])

proc removeCerata*(cerata: openArray[string]) =
  let cluster = checkCerata(cerata)

  printHeader()

  for idx, nom in cluster:
    let ceras = parseCeras(nom)

    printContent(idx, $ceras,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $remove)

    for line in lines($radLibLocal / $ceras / $sum):
      removeFile(DirSep & line.split()[2])

    removeDir($radLibLocal / $ceras)

    cursorUp 1
    eraseLine()

    printFooter(idx, $ceras,
      case ceras.ver
      of $git:
        ceras.cmt
      else:
        ceras.ver
    , $remove)

proc searchCerata*(pattern: openArray[string]) =
  var cerata: seq[string]

  for ceras in walkDir($radLibClustersCerata, true, skipSpecial = true):
    for nom in pattern:
      if nom.toLowerAscii() in ceras[1]:
        cerata.add(ceras[1])

  if cerata.len() == 0:
    exit(QuitFailure)

  sort(cerata)

  printCerata(cerata)
