# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[algorithm, os, osproc, sequtils, strformat, strutils, tables, terminal, times],
  constants, teeth,
  hashlib/misc/blake3, parsetoml, toposort

proc rad_ceras_clean*() =
  removeDir(RAD_PATH_RAD_LOGS)
  removeDir(RAD_PATH_RAD_TEMPORARY)

proc rad_ceras_distclean*() =
  removeDir(RAD_PATH_RAD_CACHE_BINARIES)
  removeDir(RAD_PATH_RAD_CACHE_SOURCES)
  removeDir(RAD_PATH_RAD_CACHE_VENOM)

  rad_ceras_clean()

# Check if the `ceras` source is extracted
proc rad_ceras_extract_source(file: string): bool =
  toSeq(walkDir(parentDir(file))).len > 1

# Return the full path to the `ceras` file
func rad_ceras_path(nom: string): string =
  RAD_PATH_RAD_LIBRARY_CLUSTERS_GLAUCUS / nom / RAD_FILE_CERAS

# Check if the full path to the `ceras` file exists
proc rad_ceras_exist(nom: string) =
  if not fileExists(rad_ceras_path(nom)):
    styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    rad_exit(QuitFailure)

# Parse the `ceras` file
proc rad_ceras_parse(nom: string): TomlValueRef =
  parseFile(rad_ceras_path(nom))

proc rad_ceras_print*(cerata: openArray[string]) =
  for nom in cerata.deduplicate():
    rad_ceras_exist(nom)

    let ceras = rad_ceras_parse(nom)

    const NONE = ansiForegroundColorCode(fgRed) & "None" & ansiForegroundColorCode(fgDefault)

    styledEcho &"{\"Name\":13} :: ", fgBlue, styleBright, nom, resetStyle
    echo &"{\"Version\":13} :: ", ceras{"cmt"}.getStr(ceras{"ver"}.getStr(NONE))
    echo &"{\"URL\":13} :: ", ceras{"url"}.getStr(NONE)
    echo &"{\"Checksum\":13} :: ", ceras{"sum"}.getStr(NONE)
    echo &"{\"Dependencies\":13} :: ", ceras{"run"}.getStr(NONE)

    echo ""

proc rad_ceras_print_header(command: string, length: int) =
  echo &"{command} {length} cerata..."

  echo ""

  styledEcho styleBright, &"{\"Command\":13} :: {\"Name\":24}{\"Version\":24}{\"Status\":13}Time", resetStyle

# Resolve dependencies using topological sorting
proc rad_ceras_resolve_dependencies(nom: string, dependencies: var Table[string, seq[string]], run = true) =
  # Don't use `{}` because we don't want an empty string "" in our Table
  dependencies[nom] = try: rad_ceras_parse(nom)[if run: "run" else: "bld"].getStr().split() except CatchableError: @[]

  if dependencies[nom].len() > 0:
    for dependency in dependencies[nom]:
      rad_ceras_resolve_dependencies(dependency, dependencies, if run: true else: false)

func rad_ceras_stage(log, nom, ver: string, stage = RAD_DIRECTORY_SYSTEM): int =
  # We only use `nom` and `ver` from `ceras`
  #
  # All phases need to be called sequentially to prevent the loss of the
  # current working directory...
  execCmd(&"{RAD_TOOTH_SHELL} {RAD_TOOTH_SHELL_COMMAND_FLAGS} 'nom={nom} ver={ver} . {RAD_PATH_RAD_LIBRARY_CLUSTERS_GLAUCUS}/{nom}/{stage} && ceras_prepare $1 && ceras_configure $1 && ceras_build $1 && ceras_check $1 && ceras_install $1'" % &">> {log} 2>&1")

# Swallow cerata
proc rad_ceras_swallow(cerata: openArray[string]) =
  var
    clones: seq[(array[3, string], string)]
    downloads: seq[(array[5, string], string)]

    counter, length: int

  for nom in cerata:
    let
      ceras = rad_ceras_parse(nom)

      ver = ceras{"ver"}.getStr()
      url = ceras{"url"}.getStr()

    # Check for virtual cerata
    if url.isEmptyOrWhitespace():
      styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

      continue

    let
      cmt = ceras{"cmt"}.getStr()
      sum = ceras{"sum"}.getStr()

      path = getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_SOURCES) / nom
      archive = path / lastPathPart(url)

    if dirExists(path):
      if ver == "git":
        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{cmt:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
      else:
        if rad_verify_file(archive, sum):
          if not rad_ceras_extract_source(archive):
            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            discard rad_extract_archive(archive, path)

            cursorUp 1
            eraseLine()

          styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
        else:
          removeDir(path)

          downloads &= ([nom, ver, sum, path, archive], &"{RAD_CERAS_WGET2} -q -O {archive} -c -N {url}")
    else:
      if ver == "git":
        clones &= ([nom, cmt, path], &"{RAD_TOOTH_GIT} {RAD_TOOTH_GIT_CLONE_FLAGS} {url} {path} -q && {RAD_TOOTH_GIT} -C {path} {RAD_TOOTH_GIT_CHECKOUT_FLAGS} {cmt} -q")
      else:
        downloads &= ([nom, ver, sum, path, archive], &"{RAD_CERAS_WGET2} -q -O {archive} -c -N {url}")

  length = downloads.len()

  if length > 0:
    echo ""

    rad_ceras_print_header("Download, verify and extract", length)

    let cluster = downloads.unzip()[0]

    discard execProcesses(downloads.unzip()[1], n = 5, beforeRunEvent =
      proc (i: int) =
        let
          ceras = cluster[i]

          nom = ceras[0]
          ver = ceras[1]

          path = ceras[3]

        styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"download\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        createDir(path)

        counter += 1
    , afterRunEvent =
      proc (i: int; p: Process) =
        let
          ceras = cluster[i]

          nom = ceras[0]
          ver = ceras[1]
          sum = ceras[2]

          path = ceras[3]
          archive = ceras[4]

        cursorUp counter - i
        eraseLine()

        styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"verify\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        if rad_verify_file(archive, sum):
          cursorUp 1
          eraseLine()

          styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

          discard rad_extract_archive(archive, path)
        else:
          cursorUp 1
          eraseLine()

          styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{ver:24}{\"sum\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

          rad_exit(QuitFailure)

        cursorUp 1
        eraseLine()

        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

        cursorDown counter - i
    )

  counter = 0

  length = clones.len()

  if length > 0:
    echo ""

    rad_ceras_print_header("Clone and checkout", length)

    let cluster = clones.unzip()[0]

    discard execProcesses(clones.unzip()[1], n = 5, beforeRunEvent =
      proc (i: int) =
        let
          ceras = cluster[i]

          nom = ceras[0]
          cmt = ceras[1]

        styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{cmt:24}{\"clone\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        counter += 1
    , afterRunEvent =
      proc (i: int; p: Process) =
        let
          ceras = cluster[i]

          nom = ceras[0]
          cmt = ceras[1]

        cursorUp counter - i
        eraseLine()

        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{cmt:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

        cursorDown counter - i
    )

proc rad_ceras_check*(cerata: openArray[string], run = true): seq[string] =
  var dependencies: Table[string, seq[string]]

  for nom in cerata.deduplicate():
    rad_ceras_exist(nom)

    rad_ceras_resolve_dependencies(nom, dependencies, if run: true else: false)

  topoSort(dependencies)

proc rad_ceras_envenomate*(cerata: openArray[string], stage = RAD_DIRECTORY_SYSTEM, resolve = true) =
  var
    status: int
    log: string

  let
    cluster = rad_ceras_check(cerata, false)
    length = cluster.len()

  rad_ceras_print_header("Swallow", length)

  # Swallow cluster in parallel
  rad_ceras_swallow(cluster)

  echo ""

  rad_ceras_print_header("Envenomate", if resolve: length else: cerata.len())

  for nom in (if resolve: cluster else: cerata.toSeq()):
    let
      ceras = rad_ceras_parse(nom)

      ver = ceras{"ver"}.getStr()
      cmt = ceras{"cmt"}.getStr()

      url = ceras{"url"}.getStr()

    styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {nom:24}{(if ver == \"git\": cmt else: ver):24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    log = getEnv(RAD_ENVIRONMENT_DIRECTORY_LOGS) / nom & CurDir & RAD_DIRECTORY_LOGS

    if stage == RAD_DIRECTORY_SYSTEM:
      if fileExists(RAD_PATH_RAD_CACHE_VENOM / nom / &"{nom}{(if not url.isEmptyOrWhitespace(): '-' & ver else: \"\")}{(if ver == \"git\": '-' & cmt else: \"\")}{RAD_FILE_ARCHIVE}"):
        cursorUp 1
        eraseLine()

        styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{(if ver == \"git\": cmt else: ver):24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

        continue

      putEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC, RAD_PATH_RAD_CACHE_VENOM / nom / RAD_DIRECTORY_SAC)
      createDir(getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC))

    status = rad_ceras_stage(log, nom, ver, stage)

    cursorUp 1
    eraseLine()

    if status != 0:
      styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{(if ver == \"git\": cmt else: ver):24}{status:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

      rad_exit(QuitFailure)

    if stage == RAD_DIRECTORY_SYSTEM:
      status = rad_create_archive_zstd(RAD_PATH_RAD_CACHE_VENOM / nom / &"{nom}{(if not url.isEmptyOrWhitespace(): '-' & ver else: \"\")}{(if ver == \"git\": '-' & cmt else: \"\")}{RAD_FILE_ARCHIVE}", getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC))

      if status == 0:
        rad_generate_sum(getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC), RAD_PATH_RAD_CACHE_VENOM / nom / RAD_FILE_SUM)

        removeDir(getEnv(RAD_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC))

    styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{(if ver == \"git\": cmt else: ver):24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

proc rad_ceras_install*(cerata: openArray[string]) =
  let
    cluster = rad_ceras_check(cerata)
    length = cluster.len()

  rad_ceras_print_header("Install", length)

  for nom in cluster:
    let
      ceras = rad_ceras_parse(nom)

      ver = ceras{"ver"}.getStr()
      cmt = ceras{"cmt"}.getStr()

      url = ceras{"url"}.getStr()

    styledEcho fgMagenta, styleBright, &"{\"Install\":13} :+ {nom:24}{(if ver == \"git\": cmt else: ver):24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    let status = rad_extract_archive(RAD_PATH_RAD_CACHE_VENOM / nom / &"{nom}{(if not url.isEmptyOrWhitespace(): '-' & ver else: \"\")}{(if ver == \"git\": '-' & cmt else: \"\")}{RAD_FILE_ARCHIVE}", RAD_PATH_PKG_CONFIG_SYSROOT_DIR)

    cursorUp 1
    eraseLine()

    if status != 0:
      styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{(if ver == \"git\": cmt else: ver):24}{status:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

      rad_exit(QuitFailure)

    styledEcho fgGreen, &"{\"Install\":13}", fgDefault, " :+ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{(if ver == \"git\": cmt else: ver):24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

proc rad_ceras_remove*(cerata: openArray[string]) =
  let
    cluster = rad_ceras_check(cerata)
    length = cluster.len()

  rad_ceras_print_header("Remove", length)

  for nom in cluster:
    let
      ceras = rad_ceras_parse(nom)

      ver = ceras{"ver"}.getStr()
      cmt = ceras{"cmt"}.getStr()

      url = ceras{"url"}.getStr()

    styledEcho fgMagenta, styleBright, &"{\"Remove\":13} :- {nom:24}{(if ver == \"git\": cmt else: ver):24}{\"remove\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    let sum = RAD_PATH_RAD_CACHE_VENOM / nom / RAD_FILE_SUM

    for line in lines(sum):
      removeFile(RAD_PATH_PKG_CONFIG_SYSROOT_DIR / line.split()[2])

    cursorUp 1
    eraseLine()

    styledEcho fgGreen, &"{\"Remove\":13}", fgDefault, " :- ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{(if ver == \"git\": cmt else: ver):24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

proc rad_ceras_search*(pattern: openArray[string]) =
  var cerata: seq[string]

  for file in walkDir(RAD_PATH_RAD_LIBRARY_CLUSTERS_GLAUCUS, relative = true, skipSpecial = true):
    for nom in pattern:
      if nom.toLowerAscii() in file[1]:
        cerata.add(file[1])

  sort(cerata)

  rad_ceras_print(cerata)
