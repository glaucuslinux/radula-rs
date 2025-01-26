# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, sequtils, strformat, strutils, tables, terminal, times],
  constants,
  flags,
  tools,
  toml_serialization,
  toposort

type Ceras = object
  nom, ver, url, sum, bld, run, nop = $Nil

proc `$`(self: Ceras): string =
  self.nom

proc cleanCerata*() =
  removeDir($radLog)
  removeDir($radTmp)

proc distcleanCerata*() =
  cleanCerata()

  removeDir($radPkgCache)
  removeDir($radSrcCache)

proc parseCeras(nom: string): Ceras =
  let path = $radClustersCerataLib / nom / $ceras

  if not fileExists(path):
    abort(&"""{"nom":8}{nom:48}""")

  Toml.loadFile(path, Ceras)

proc printCerata*(cerata: openArray[string]) =
  for nom in cerata.deduplicate():
    let ceras = parseCeras(nom)

    echo &"""
nom  :: {ceras}
ver  :: {ceras.ver}
url  :: {ceras.url}
sum  :: {ceras.sum}
bld  :: {ceras.bld}
run  :: {ceras.run}
nop  :: {ceras.nop}
"""

proc printContent(idx: int, nom, ver, cmd: string) =
  styledEcho fgMagenta,
    styleBright, &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc printFooter(idx: int, nom, ver, cmd: string) =
  cursorUp 1
  eraseLine()

  echo &"""{idx + 1:<8}{nom:24}{ver:24}{cmd:8}{now().format("hh:mm tt")}"""

proc printHeader() =
  echo &"""
{'~'.repeat(72)}
{"idx":8}{"nom":24}{"ver":24}{"cmd":8}fin
{'~'.repeat(72)}"""

proc resolveDeps(nom: string, deps: var Table[string, seq[string]], run = true) =
  let
    ceras = parseCeras(nom)
    dep = if run: ceras.run else: ceras.bld

  deps[$ceras] =
    if dep == $Nil:
      @[]
    else:
      dep.split()

  for dep in deps[$ceras]:
    resolveDeps(dep, deps, run)

proc sortCerata(cerata: openArray[string], run = true): seq[string] =
  var deps: Table[string, seq[string]]

  for nom in cerata.deduplicate():
    resolveDeps(nom, deps, run)

  topoSort(deps)

proc prepareCerata(cerata: openArray[string]) =
  for idx, nom in cerata:
    let ceras = parseCeras(nom)

    printContent(idx, $ceras, ceras.ver, $prepare)

    # Skip virtual cerata
    if ceras.url == $Nil:
      printFooter(idx, $ceras, ceras.ver, $prepare)

      continue

    let
      src = getEnv($SRCD) / $ceras
      tmp = getEnv($TMPD) / $ceras

    if ceras.sum == $Nil:
      if not dirExists(src):
        discard gitCloneRepo(ceras.url, src)
        discard gitCheckoutRepo(src, ceras.ver)

      copyDirWithPermissions(src, tmp)
    else:
      let archive = src / lastPathPart(ceras.url)

      if not verifyFile(archive, ceras.sum):
        removeDir(src)
        createDir(src)

        discard downloadFile(archive, ceras.url)

      if verifyFile(archive, ceras.sum):
        createDir(tmp)
        discard extractTar(archive, tmp)
      else:
        abort(&"""{"sum":8}{ceras:24}{ceras.ver:24}""")

    printFooter(idx, $ceras, ceras.ver, $prepare)

proc buildCerata*(cerata: openArray[string], stage = $native, resolve = true) =
  printHeader()

  let cluster = sortCerata(cerata, false)

  prepareCerata(cluster)

  printHeader()

  for idx, nom in (if resolve: cluster else: cerata.toSeq()):
    let
      ceras = parseCeras(nom)
      archive =
        $radPkgCache / $ceras /
        &"""{ceras}{(if ceras.url == $Nil: "" else: '-' & ceras.ver)}{tarZst}"""
      log = open(
        getEnv($LOGD) / &"""{ceras}{(if stage == $native: "" else: CurDir & stage)}""",
        fmWrite,
      )
      tmp = getEnv($TMPD) / $ceras

    printContent(idx, $ceras, ceras.ver, $build)

    if stage == $native:
      if fileExists(archive):
        printFooter(idx, $ceras, ceras.ver, $build)

        continue

      createDir(getEnv($LOGD))

      putEnv($SACD, $radPkgCache / $ceras / $sac)
      createDir(getEnv($SACD))

    if stage != $toolchain:
      setEnvFlags()

      if $radFlags.lto in $ceras.nop:
        setEnvFlagsNopLto()

    if $radFlags.parallel in $ceras.nop:
      setEnvFlagsNopParallel()

    putEnv($MAKEFLAGS, $radFlags.make)

    if dirExists(tmp):
      setCurrentDir(tmp)
    if dirExists(tmp / &"{ceras}-{ceras.ver}"):
      setCurrentDir(tmp / &"{ceras}-{ceras.ver}")

    # Only use `nom` and `ver` from `ceras`
    #
    # Call all phases sequentially to preserve the current working dir
    let shell = execCmdEx(
      &"""{sh} -c 'nom={ceras} ver={ceras.ver} {CurDir} {$radClustersCerataLib / $ceras / (if stage == $native: $build else: $build & CurDir & stage)} && prepare && configure && build && package'"""
    )

    log.writeLine(shell.output.strip())
    log.close()

    if shell.exitCode != QuitSuccess:
      abort(&"{shell.exitCode:<8}{ceras:24}{ceras.ver:24}")

    if stage == $native:
      let
        sac = getEnv($SACD)
        status = createTarZst(archive, sac)

      if status == QuitSuccess:
        genSum(sac, $radPkgCache / $ceras / $sum)
        removeDir(sac)

      if $bootstrap in $ceras.nop:
        discard extractTar(archive, $DirSep)

    printFooter(idx, $ceras, ceras.ver, $build)

proc installCerata*(
    cerata: openArray[string], cache = $radPkgCache, fs = $DirSep, lib = $radPkgLib
) =
  printHeader()

  let cluster = sortCerata(cerata)

  for idx, nom in cluster:
    let ceras = parseCeras(nom)

    printContent(idx, $ceras, ceras.ver, $install)

    discard extractTar(
      cache / $ceras /
        &"""{ceras}{(if ceras.url == $Nil: "" else: '-' & ceras.ver)}{tarZst}""",
      fs,
    )

    createDir(lib / $ceras)
    writeFile(lib / $ceras / "ver", ceras.ver)
    copyFileWithPermissions(cache / $ceras / $sum, lib / $ceras / $sum)

    printFooter(idx, $ceras, ceras.ver, $install)

proc listCerata*() =
  printCerata(walkDir($radPkgLib, true, skipSpecial = true).toSeq().unzip()[1])

proc removeCerata*(cerata: openArray[string]) =
  printHeader()

  let cluster = sortCerata(cerata)

  for idx, nom in cluster:
    let ceras = parseCeras(nom)

    printContent(idx, $ceras, ceras.ver, $remove)

    for line in lines($radPkgLib / $ceras / $sum):
      removeFile(&"{DirSep}{line.split()[2]}")

    removeDir($radPkgLib / $ceras)

    printFooter(idx, $ceras, ceras.ver, $remove)

proc searchCerata*(pattern: openArray[string]) =
  var cerata: seq[string]

  for ceras in walkDir($radClustersCerataLib, true, skipSpecial = true):
    for nom in pattern:
      if nom.toLowerAscii() in ceras[1]:
        cerata.add(ceras[1])

  if cerata.len() == QuitSuccess:
    exit(QuitFailure)

  sort(cerata)

  printCerata(cerata)
