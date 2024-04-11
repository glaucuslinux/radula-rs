# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  osproc,
  sequtils,
  strformat,
  strutils,
  tables,
  terminal,
  times
]

import
  constants,
  teeth

import
  hashlib/misc/blake3,
  parsetoml,
  toposort

# Check if the `ceras` source is extracted
proc radula_ceras_extract_source*(file: string): bool =
  if toSeq(walkDir(parentDir(file))).len > 1:
    return true

# Return the full path to the `ceras` file
func radula_ceras_path*(nom: string): string =
  RADULA_PATH_RADULA_CLUSTERS_GLAUCUS / nom / RADULA_FILE_CERAS

# Check if the full path to the `ceras` file exists
proc radula_ceras_exist*(nom: string) =
  if not fileExists(radula_ceras_path(nom)):
    styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    radula_exit(QuitFailure)

# Parse the `ceras` file
proc radula_ceras_parse*(nom: string): TomlValueRef =
  parseFile(radula_ceras_path(nom))

# Return the full path to the `ceras` source directory
func radula_ceras_path_source*(nom: string): string =
  RADULA_PATH_RADULA_CACHE_SOURCES / nom

proc radula_ceras_print*(cerata: seq[string]) =
  for nom in cerata.deduplicate():
    radula_ceras_exist(nom)

    let ceras = radula_ceras_parse(nom)

    const NONE = ansiForegroundColorCode(fgRed) & "None" & ansiForegroundColorCode(fgDefault)

    styledEcho &"{\"Name\":13} :: ", fgBlue, styleBright, nom, resetStyle
    echo &"{\"Version\":13} :: ", ceras{"cmt"}.getStr(ceras{"ver"}.getStr(NONE))
    echo &"{\"URL\":13} :: ", ceras{"url"}.getStr(NONE)
    echo &"{\"Checksum\":13} :: ", ceras{"sum"}.getStr(NONE)
    echo &"{\"Dependencies\":13} :: ", ceras{"dep"}.getStr(NONE)
    echo &"{\"Dependencies\":13} :: ", ceras{"run"}.getStr(NONE)

    echo ""

proc radula_ceras_print_header*() =
  echo ""

  styledEcho styleBright, &"{\"Behavior\":13} :: {\"Name\":24}{\"Version\":24}{\"Status\":13}Time", resetStyle

# Resolve dependencies using topological sorting
proc radula_ceras_resolve_dependencies*(nom: string, dependencies: var Table[string, seq[string]]) =
  # Don't use `{}` because we don't want an empty string "" in our Table
  dependencies[nom] = try: radula_ceras_parse(nom)["dep"].getStr().split() except CatchableError: @[]

  if dependencies[nom].len() > 0:
    for dependency in dependencies[nom]:
      radula_ceras_resolve_dependencies(dependency, dependencies)

# Verify the `ceras` source
proc radula_ceras_verify_source*(file, sum: string): bool =
  $count[BLAKE3](try: readFile(file) except CatchableError: "") == sum

proc radula_ceras_stage*(log, nom, ver: string, stage = RADULA_DIRECTORY_SYSTEM): int =
  # We only use `nom` and `ver` from `ceras`
  #
  # All phases need to be called sequentially to prevent the loss of the
  # current working directory...
  execCmd(&"{RADULA_CERAS_YASH} {RADULA_TOOTH_SHELL_COMMAND_FLAGS} 'nom={nom} ver={ver} . {RADULA_PATH_RADULA_CLUSTERS_GLAUCUS}/{nom}/{stage} && ceras_prepare $1 && ceras_configure $1 && ceras_build $1 && ceras_check $1 && ceras_install $1'" % [&">> {log} 2>&1"])

# Swallow cerata
proc radula_ceras_swallow*(cerata: seq[string]) =
  var
    clones: seq[(array[3, string], string)]
    downloads: seq[(array[5, string], string)]

    counter, length: int

  for nom in cerata:
    let
      ceras = radula_ceras_parse(nom)

      ver = ceras{"ver"}.getStr()
      url = ceras{"url"}.getStr()

    # Check for virtual cerata
    if url.isEmptyOrWhitespace():
      styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

      continue

    let
      cmt = ceras{"cmt"}.getStr()
      sum = ceras{"sum"}.getStr()

      path = radula_ceras_path_source(nom)
      archive = path / lastPathPart(url)

    if dirExists(path):
      if ver == "git":
        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{cmt:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
      else:
        if radula_ceras_verify_source(archive, sum):
          if not radula_ceras_extract_source(archive):
            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            discard radula_extract_archive(archive, path)

            cursorUp 1
            eraseLine()

          styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
        else:
          removeDir(path)

          downloads &= ([nom, ver, sum, path, archive], &"{RADULA_CERAS_WGET2} -q -O {archive} -c -N {url}")
    else:
      if ver == "git":
        clones &= ([nom, cmt, path], &"{RADULA_TOOTH_GIT} {RADULA_TOOTH_GIT_CLONE_FLAGS} {url} {path} -q && {RADULA_TOOTH_GIT} -C {path} {RADULA_TOOTH_GIT_CHECKOUT_FLAGS} {cmt} -q")
      else:
        downloads &= ([nom, ver, sum, path, archive], &"{RADULA_CERAS_WGET2} -q -O {archive} -c -N {url}")

  length = downloads.len()

  if length > 0:
    echo ""

    echo &"Download, verify and extract {length} cerata..."

    radula_ceras_print_header()

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

        if radula_ceras_verify_source(archive, sum):
          cursorUp 1
          eraseLine()

          styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

          discard radula_extract_archive(archive, path)
        else:
          cursorUp 1
          eraseLine()

          styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{ver:24}{\"sum\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

          radula_exit(QuitFailure)

        cursorUp 1
        eraseLine()

        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

        cursorDown counter - i
    )

  counter = 0

  length = clones.len()

  if length > 0:
    echo ""

    echo &"Clone and checkout {length} cerata..."

    radula_ceras_print_header()

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

proc radula_ceras_envenomate*(cerata: openArray[string], stage = RADULA_DIRECTORY_SYSTEM, resolve = true) =
  var
    cerata = cerata.deduplicate()

    dependencies: Table[string, seq[string]]

    length: int

    log: string

  for nom in cerata:
    radula_ceras_exist(nom)

    radula_ceras_resolve_dependencies(nom, dependencies)

  let cluster = toposort(dependencies)

  length = cluster.len()

  echo &"Swallow {length} cerata..."

  radula_ceras_print_header()

  # Swallow cluster in parallel
  radula_ceras_swallow(cluster)

  echo ""

  echo &"Envenomate {(if resolve: length else: cerata.len())} cerata..."

  radula_ceras_print_header()

  for nom in (if resolve: cluster else: cerata):
    let
      ceras = radula_ceras_parse(nom)

      ver = ceras{"ver"}.getStr()
      cmt = ceras{"cmt"}.getStr()

      url = ceras{"url"}.getStr()

    styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {nom:24}{(if ver == \"git\": cmt else: ver):24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    case stage
      of RADULA_DIRECTORY_CROSS:
        log = getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)
      of RADULA_DIRECTORY_SYSTEM:
        log = getEnv(RADULA_ENVIRONMENT_FILE_SYSTEM_LOG)

        putEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC, RADULA_PATH_RADULA_CACHE_VENOM / nom / RADULA_DIRECTORY_SAC)
        createDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC))
      of RADULA_DIRECTORY_TOOLCHAIN:
        log = getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)

    let status = radula_ceras_stage(log, nom, ver, stage)

    cursorUp 1
    eraseLine()

    if status != 0:
      styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{(if ver == \"git\": cmt else: ver):24}{status:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

      radula_exit(QuitFailure)

    if stage == RADULA_DIRECTORY_SYSTEM:
      let status = radula_create_archive_zstd(RADULA_PATH_RADULA_CACHE_VENOM / nom / &"{nom}{(if not url.isEmptyOrWhitespace(): '-' & ver else: \"\")}{(if ver == \"git\": '-' & cmt else: \"\")}{RADULA_FILE_ARCHIVE}", getEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC))

      if status == 0:
        radula_generate_sum(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC), RADULA_PATH_RADULA_CACHE_VENOM / nom / RADULA_FILE_SUM)

        removeDir(getEnv(RADULA_ENVIRONMENT_DIRECTORY_CACHE_VENOM_SAC))

    styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{(if ver == \"git\": cmt else: ver):24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

proc radula_ceras_install*(cerata: openArray[string]) =
  radula_ceras_envenomate(cerata)
