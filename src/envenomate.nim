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

# Extract tarballs
proc radula_behave_extract*(file, path: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {file} -C {path}")

# Verify `BLAKE3` sum of source tarball
proc radula_behave_verify*(file, sum: string): bool =
    $count[BLAKE3](readFile(file)) == sum

# Swallow cerata
proc radula_behave_swallow*(noms: seq[string]) =
    var
        clones: seq[(array[4, string], string)]
        downloads: seq[(array[4, string], string)]

        length: int

    for nom in noms:
        let
            ceras = radula_behave_ceras_parse(nom)

            ver =
                try:
                    ceras["ver"].getStr()
                except CatchableError:
                    ""
            url =
                try:
                    ceras["url"].getStr()
                except CatchableError:
                    ""

        if (url.isEmptyOrWhitespace()):
            styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

            continue

        let
            path = radula_behave_ceras_path_source(nom)
            file = path / lastPathPart(url)

        if dirExists(path):
            if ver == "git":
                let cmt = ceras["cmt"].getStr()

                styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{cmt:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

                continue
            else:
                let sum = ceras["sum"].getStr()

                if fileExists(file) and radula_behave_verify(file, sum):
                    styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

                    continue
                else:
                    removeDir(path)
                    createDir(path)

                    downloads &= ([nom, ver, url, sum], &"{RADULA_CERAS_AXEL} {url} --output {path} --no-clobber --quiet")
        else:
            if ver == "git":
                let cmt = ceras["cmt"].getStr()

                clones &= ([nom, cmt, url, path], &"{RADULA_TOOTH_GIT} {RADULA_TOOTH_GIT_CLONE_FLAGS} {url} {path} --quiet && {RADULA_TOOTH_GIT} -C {path} {RADULA_TOOTH_GIT_CHECKOUT_FLAGS} {cmt} --quiet")
            else:
                createDir(path)

                downloads &= ([nom, ver, url, ceras["sum"].getStr()], &"{RADULA_CERAS_AXEL} {url} --output {path} --no-clobber --quiet")

    length = downloads.unzip()[0].len()

    if length > 0:
        echo ""

        echo &"Download {length} cerata..."

        radula_behave_ceras_print_header()

        for i, cluster in downloads.distribute(length div 5):
            for ceras in cluster.unzip()[0]:
                let
                    nom = ceras[0]
                    ver = ceras[1]

                styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"download\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle
            discard execProcesses(cluster.unzip()[1])

        echo ""

        echo &"Verify and extract {length} cerata..."

        radula_behave_ceras_print_header()

        for ceras in downloads.unzip()[0]:
            let
                nom = ceras[0]
                ver = ceras[1]
                url = ceras[2]
                sum = ceras[3]

                path = radula_behave_ceras_path_source(nom)
                file = path / lastPathPart(url)

            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"verify\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            cursorUp 1
            eraseLine()

            if radula_behave_verify(file, sum):
                styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{ver:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

                discard radula_behave_extract(file, path)
            else:
                styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:24}{ver:24}{\"sum\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

                radula_behave_exit(QuitFailure)

            cursorUp 1
            eraseLine()

            styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

    length = clones.len()

    if length > 0:
        echo ""

        echo &"Clone {length} cerata..."

        radula_behave_ceras_print_header()

        for ceras in clones.unzip()[0]:
            let
                nom = ceras[0]
                cmt = ceras[1]

            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {nom:24}{cmt:24}{\"clone\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        discard execProcesses(clones.unzip()[1])

proc radula_behave_stage*(nom, ver, stage = RADULA_DIRECTORY_SYSTEM, log_file: string): (string, int) =
    # We only use `nom` and `ver` from the `ceras`file
    #
    # All phases need to be called sequentially to prevent the loss of the
    # current working directory...
    execCmdEx(RADULA_CERAS_DASH & ' ' & RADULA_TOOTH_SHELL_FLAGS & ' ' & (&"nom={nom} ver={ver} . {RADULA_PATH_RADULA_CLUSTERS}/{RADULA_DIRECTORY_GLAUCUS}/{nom}/{stage} && prepare $1 && configure $1 && build $1 && check $1 && install $1" % [&">> {log_file} 2>&1"]).quoteShell)

proc radula_behave_envenomate*(noms: openArray[string], stage: string = RADULA_DIRECTORY_SYSTEM, resolve: bool = true) =
    var
        log_file: string

        noms = noms.deduplicate()

        concentrates: Table[string, seq[string]]

        length: int

    for nom in noms:
        if not radula_behave_ceras_exist(nom):
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            radula_behave_exit(QuitFailure)

        if resolve:
            radula_behave_ceras_concentrates_resolve(nom, concentrates)

    if resolve:
        noms = toposort(concentrates)

    length = noms.len()

    echo &"Swallow {length} cerata..."

    radula_behave_ceras_print_header()

    # Swallow cerata in parallel
    radula_behave_swallow(noms)

    echo ""

    echo &"Envenomate {length} cerata..."

    radula_behave_ceras_print_header()

    for nom in noms:
        let
            ceras = radula_behave_ceras_parse(nom)

            ver =
                try:
                    ceras["ver"].getStr()
                except CatchableError:
                    ""
            cmt =
                try:
                    ceras["cmt"].getStr()
                except CatchableError:
                    ""

        if ver == "git":
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {nom:24}{cmt:24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle
        else:
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {nom:24}{ver:24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        case stage
        of RADULA_DIRECTORY_CROSS:
            log_file = getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)
        of RADULA_DIRECTORY_TOOLCHAIN:
            log_file = getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)

        let output = radula_behave_stage(nom, ver, stage, log_file)

        cursorUp 1
        eraseLine()

        if output[1] != 0:
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {nom:48}{output[1]:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            radula_behave_exit(QuitFailure)

        if ver == "git":
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{cmt:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
        else:
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{nom:24}", resetStyle, &"{ver:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
