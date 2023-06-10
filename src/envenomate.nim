# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  osproc,
  sequtils,
  strformat,
  strutils,
  terminal,
  times
]

import
  ceras,
  constants,
  teeth

import
  hashlib/misc/blake3,
  parsetoml,
  toposort

proc radula_behave_stage*(nom, ver, stage = RADULA_DIRECTORY_SYSTEM, log: string): int =
  # We only use `nom` and `ver` from the `ceras`file
  #
  # All phases need to be called sequentially to prevent the loss of the
  # current working directory...
  execCmd(&"{RADULA_CERAS_YASH} {RADULA_TOOTH_SHELL_COMMAND_FLAGS} 'nom={nom} ver={ver} . {RADULA_PATH_RADULA_CLUSTERS_GLAUCUS}/{nom}/{stage} && prepare $1 && configure $1 && build $1 && check $1 && install $1'" % [&">> {log} 2>&1"])

# Swallow cerata
proc radula_behave_swallow*(cerata: seq[string]) =
  var
    clones: seq[(array[3, string], string)]
    downloads: seq[(array[5, string], string)]

    counter, length: int

  for nom in cerata:
    let
      ceras = radula_behave_ceras_parse_ceras(nom)

      ver = ceras{"ver"}.getStr()
      url = ceras{"url"}.getStr()

    # Check for virtual cerata
    if url.isEmptyOrWhitespace():
      styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

      continue

    let
      cmt = ceras{"cmt"}.getStr()
      sum = ceras{"sum"}.getStr()

      path = radula_behave_ceras_path_source(nom)
      archive = path / lastPathPart(url)

    if dirExists(path):
      if ver == "git":
        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{cmt:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
      else:
        if radula_behave_ceras_verify_source(archive, sum):
          if not radula_behave_ceras_extract_source(archive):
            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            discard radula_behave_extract_archive(archive, path)

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

    radula_behave_ceras_print_header()

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

        if radula_behave_ceras_verify_source(archive, sum):
          cursorUp 1
          eraseLine()

          styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

          discard radula_behave_extract_archive(archive, path)
        else:
          cursorUp 1
          eraseLine()

          styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{ver:24}{\"sum\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

          radula_behave_exit(QuitFailure)

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

    radula_behave_ceras_print_header()

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

proc radula_behave_envenomate*(cerata: openArray[string], stage: string = RADULA_DIRECTORY_SYSTEM, resolve: bool = true) =
  var
    cerata = cerata.deduplicate()

    concentrates: Table[string, seq[string]]

    length: int

    log: string

  for nom in cerata:
    if not radula_behave_ceras_exist_ceras(nom):
      styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

      radula_behave_exit(QuitFailure)

    radula_behave_ceras_resolve_concentrates(nom, concentrates)

  let cluster = toposort(concentrates)

  length = cluster.len()

  echo &"Swallow {length} cerata..."

  radula_behave_ceras_print_header()

  # Swallow cerata in parallel
  radula_behave_swallow(cluster)

  echo ""

  echo &"Envenomate {(if resolve: length else: cerata.len())} cerata..."

  radula_behave_ceras_print_header()

  for nom in (if resolve: cluster else: cerata):
    let
      ceras = radula_behave_ceras_parse_ceras(nom)

      ver = ceras{"ver"}.getStr()
      cmt = ceras{"cmt"}.getStr()

    styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {nom:24}{(if ver == \"git\": cmt else: ver):24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

    case stage
      of RADULA_DIRECTORY_CROSS:
        log = getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)
      of RADULA_DIRECTORY_SYSTEM:
        log = getEnv(RADULA_ENVIRONMENT_FILE_SYSTEM_LOG)

        createDir(RADULA_PATH_RADULA_CACHE_VENOM / nom / RADULA_DIRECTORY_SAC)
      of RADULA_DIRECTORY_TOOLCHAIN:
        log = getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)

    let status = radula_behave_stage(nom, ver, stage, log)

    cursorUp 1
    eraseLine()

    if status != 0:
      styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{(if ver == \"git\": cmt else: ver):24}{status:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

      radula_behave_exit(QuitFailure)

    if stage == RADULA_DIRECTORY_SYSTEM:
      let
        sac = RADULA_PATH_RADULA_CACHE_VENOM / nom / RADULA_DIRECTORY_SAC

        status = radula_behave_create_archive_zstd(RADULA_PATH_RADULA_CACHE_VENOM / nom / &"{nom}-{ver}.tar.zst", sac)

      # if status == 0:
        # removeDir(sac)

    styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{(if ver == \"git\": cmt else: ver):24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
