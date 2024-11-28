# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, sequtils, strformat, strutils, tables, terminal, times],
  constants,
  flags,
  tools,
  hashlib/misc/blake3,
  toml_serialization,
  toposort

type Ceras = object
  nom, ver, cmt, url, sum, bld, run, nop = $Nil

func `$`(self: Ceras): string =
  self.nom

proc cleanCerata*() =
  removeDir($radLog)
  removeDir($radTmp)

proc distcleanCerata*() =
  cleanCerata()

  removeDir($radPkgCache)
  removeDir($radSrcCache)

proc getCerasPath(nom: string): string =
  $radClustersCerataLib / nom / $ceras

proc checkCerasExist(nom: string) =
  if not fileExists(getCerasPath(nom)):
    abort(&"""{"nom":8}{nom:48}""")

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
    echo &"nop  :: {ceras.nop}"

    echo ""

proc printContent(idx: int, nom, ver, cmd: string) =
  styledEcho fgMagenta,
    styleBright, &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc printFooter(idx: int, nom, ver, cmd: string) =
  echo &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc printHeader() =
  echo &"""{"idx":8}{"nom":24}{"ver":24}{"cmd":8}fin"""
  echo '~'.repeat(72)

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

proc sortCerata*(cerata: openArray[string], run = true): seq[string] =
  var deps: Table[string, seq[string]]

  for nom in cerata.deduplicate():
    checkCerasExist(nom)

    resolveDeps(nom, deps, if run: true else: false)

  topoSort(deps)

proc prepareCerata(cerata: openArray[string]) =
  for idx, nom in cerata:
    let ceras = parseCeras(nom)

    # Check for virtual cerata
    case ceras.url
    of $Nil:
      printFooter(idx, $ceras, ceras.ver, $prepare)

      continue

    let
      src = getEnv($SRCD) / $ceras
      tmp = getEnv($TMPD) / $ceras

    case ceras.ver
    of $git:
      printContent(idx, $ceras, ceras.cmt, $prepare)

      if not dirExists(src):
        discard gitCloneRepo(ceras.url, src)
        discard gitCheckoutRepo(src, ceras.cmt)

      copyDirWithPermissions(src, tmp)

      cursorUp 1
      eraseLine()

      printFooter(idx, $ceras, ceras.cmt, $prepare)
    else:
      let archive = src / lastPathPart(ceras.url)

      printContent(idx, $ceras, ceras.ver, $prepare)

      if not verifyFile(archive, ceras.sum):
        removeDir(src)
        createDir(src)

        discard downloadFile(archive, ceras.url)

      if verifyFile(archive, ceras.sum):
        createDir(tmp)
        discard extractTar(archive, tmp)

        cursorUp 1
        eraseLine()

        printFooter(idx, $ceras, ceras.ver, $prepare)
      else:
        abort(&"""{"sum":8}{ceras:24}{ceras.ver:24}""")

proc buildCerata*(cerata: openArray[string], stage = $native, resolve = true) =
  printHeader()

  let cluster = sortCerata(cerata, false)

  prepareCerata(cluster)

  echo ""

  printHeader()

  for idx, nom in (if resolve: cluster else: cerata.toSeq()):
    let ceras = parseCeras(nom)

    printContent(
      idx,
      $ceras,
      case ceras.ver
      of $git: ceras.cmt
      else: ceras.ver
      ,
      $build,
    )

    case stage
    of $native:
      if fileExists(
        $radPkgCache / $ceras /
          &"""{ceras}{(
          case ceras.url
          of $Nil: ""
          else: '-' & ceras.ver
        )}{(
          case ceras.ver
          of $git: '-' & ceras.cmt
          else: ""
        )}{tarZst}"""
      ):
        cursorUp 1
        eraseLine()

        printFooter(
          idx,
          $ceras,
          case ceras.ver
          of $git: ceras.cmt
          else: ceras.ver
          ,
          $build,
        )

        continue

      putEnv($SACD, $radPkgCache / $ceras / $sac)
      createDir(getEnv($SACD))

    if dirExists(getEnv($TMPD) / $ceras):
      setCurrentDir(getEnv($TMPD) / $ceras)

    if dirExists(getEnv($TMPD) / $ceras / &"{ceras}-{ceras.ver}"):
      setCurrentDir(getEnv($TMPD) / $ceras / &"{ceras}-{ceras.ver}")

    if stage != $toolchain:
      setEnvFlags()

      if $lto in $ceras.nop:
        setEnvFlagsNopLto()

    # We only use `nom` and `ver` from `ceras`
    #
    # All phases need to be called sequentially to prevent the loss of the
    # current working dir...
    var status = execCmd(
      &"""{sh} {shellCommand} 'nom={ceras} ver={ceras.ver} {CurDir} {$radClustersCerataLib / $ceras / (
        case stage
        of $native: $build
        else: $build & CurDir & stage
      )} &&
      prepare $1 &&
      configure >$1 &&
      build >$1 &&
      package >$1'""" %
        &"""> {getEnv($LOGD) / (
        case stage
        of $native: $ceras
        else:
          createDir(getEnv($LOGD) / $stage)
          $stage / $ceras
      )}{CurDir}{log} 2>&1"""
    )

    if status != 0:
      abort(
        &"""{status:<8}{ceras:24}{(
          case ceras.ver
          of $git: ceras.cmt
          else: ceras.ver
        ):24}"""
      )

    case stage
    of $native:
      status = createTarZst(
        $radPkgCache / $ceras /
          &"""{ceras}{(
            case ceras.url
            of $Nil: ""
            else: '-' & ceras.ver
          )}{(
            case ceras.ver
            of $git: '-' & ceras.cmt
            else: ""
          )}{tarZst}""",
        getEnv($SACD),
      )

      if status == 0:
        genSum(getEnv($SACD), $radPkgCache / $ceras / $sum)

        removeDir(getEnv($SACD))

    cursorUp 1
    eraseLine()

    printFooter(
      idx,
      $ceras,
      case ceras.ver
      of $git: ceras.cmt
      else: ceras.ver
      ,
      $build,
    )

proc installCerata*(
    cerata: openArray[string], cache = $radPkgCache, fs = $DirSep, lib = $radPkgLib
) =
  printHeader()

  let cluster = sortCerata(cerata)

  for idx, nom in cluster:
    let ceras = parseCeras(nom)

    printContent(
      idx,
      $ceras,
      case ceras.ver
      of $git: ceras.cmt
      else: ceras.ver
      ,
      $install,
    )

    let status = extractTar(
      cache / $ceras /
        &"""{ceras}{(
          case ceras.url
          of $Nil: ""
          else: '-' & ceras.ver
        )}{(
          case ceras.ver
          of $git: '-' & ceras.cmt
          else: ""
        )}{tarZst}""",
      fs,
    )

    if status != 0:
      abort(
        &"""{status:<8}{ceras:24}{(
          case ceras.ver
          of $git: ceras.cmt
          else: ceras.ver
        ):24}"""
      )

    createDir(lib / $ceras)

    writeFile(lib / $ceras / "ver", ceras.ver)

    copyFileWithPermissions(cache / $ceras / $sum, lib / $ceras / $sum)

    cursorUp 1
    eraseLine()

    printFooter(
      idx,
      $ceras,
      case ceras.ver
      of $git: ceras.cmt
      else: ceras.ver
      ,
      $install,
    )

proc listCerata*() =
  printCerata(walkDir($radPkgLib, true, skipSpecial = true).toSeq().unzip()[1])

proc removeCerata*(cerata: openArray[string]) =
  let cluster = sortCerata(cerata)

  printHeader()

  for idx, nom in cluster:
    let ceras = parseCeras(nom)

    printContent(
      idx,
      $ceras,
      case ceras.ver
      of $git: ceras.cmt
      else: ceras.ver
      ,
      $remove,
    )

    for line in lines($radPkgLib / $ceras / $sum):
      removeFile(DirSep & line.split()[2])

    removeDir($radPkgLib / $ceras)

    cursorUp 1
    eraseLine()

    printFooter(
      idx,
      $ceras,
      case ceras.ver
      of $git: ceras.cmt
      else: ceras.ver
      ,
      $remove,
    )

proc searchCerata*(pattern: openArray[string]) =
  var cerata: seq[string]

  for ceras in walkDir($radClustersCerataLib, true, skipSpecial = true):
    for nom in pattern:
      if nom.toLowerAscii() in ceras[1]:
        cerata.add(ceras[1])

  if cerata.len() == 0:
    exit(QuitFailure)

  sort(cerata)

  printCerata(cerata)
