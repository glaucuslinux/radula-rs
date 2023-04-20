# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
    asyncdispatch,
    httpclient,
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

# Clone repositories
proc radula_behave_clone*(commit, url, path: string): (string, int) =
    result = execCmdEx(&"{RADULA_TOOTH_GIT} {RADULA_TOOTH_GIT_CLONE_FLAGS} {url} {path}")

    if result[1] == 0:
        result = execCmdEx(&"{RADULA_TOOTH_GIT} {RADULA_TOOTH_GIT_CHECKOUT_FLAGS} {commit}", workingDir = path)

# Extract tarballs
proc radula_behave_extract*(file, path: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {file} -C {path}")

# Verify `BLAKE3` checksum of source tarball
proc radula_behave_verify*(file, checksum: string): bool =
    $count[BLAKE3](readFile(file)) == checksum

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        clones: seq[array[4, string]]
        downloads: seq[(array[4, string], Future[void])]

        length: int

    for name in names:
        let
            ceras = radula_behave_ceras_parse(name)

            version =
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
            styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

            continue

        let
            path = radula_behave_ceras_path_source(name)
            file = path / lastPathPart(url)

        if dirExists(path):
            if version == "git":
                let commit = ceras["cmt"].getStr()

                styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{commit:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

                continue
            else:
                styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {name:24}{version:24}{\"verify\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

                cursorUp 1
                eraseLine()

                if fileExists(file) and radula_behave_verify(file, ceras["sum"].getStr()):
                    styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

                    continue
                else:
                    removeDir(path)
                    createDir(path)

                    downloads &= ([name, version, url, ceras["sum"].getStr()], newAsyncHttpClient().downloadFile(url, file))
        else:
            if version == "git":
                clones &= [name, ceras["cmt"].getStr(), url, path]
            else:
                createDir(path)

                downloads &= ([name, version, url, ceras["sum"].getStr()], newAsyncHttpClient().downloadFile(url, file))

    length = downloads.unzip()[0].len()

    if length > 0:
        echo ""

        echo &"Download {length} cerata..."

        radula_behave_ceras_print_header()

        for ceras in downloads.unzip()[0]:
            let
                name = ceras[0]
                version = ceras[1]
            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {name:24}{version:24}{\"download\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        waitFor all(downloads.unzip()[1])

        echo ""

        echo &"Verify and extract {length} cerata..."

        radula_behave_ceras_print_header()

        for ceras in downloads.unzip()[0]:
            let
                name = ceras[0]
                version = ceras[1]
                url = ceras[2]
                checksum = ceras[3]

                path = radula_behave_ceras_path_source(name)
                file = path / lastPathPart(url)

            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {name:24}{version:24}{\"verify\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            cursorUp 1
            eraseLine()

            if radula_behave_verify(file, checksum):
                styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {name:24}{version:24}{\"extract\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

                discard radula_behave_extract(file, path)
            else:
                styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:24}{version:24}{\"sum\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

                radula_behave_exit(1)

            cursorUp 1
            eraseLine()

            styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault

    length = clones.len()

    if length > 0:
        echo ""

        echo &"Clone {length} cerata..."

        radula_behave_ceras_print_header()

        for ceras in clones:
            let
                name = ceras[0]
                commit = ceras[1]

            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13} :@ {name:24}{commit:24}{\"clone\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            discard radula_behave_clone(commit, url = ceras[2], path = ceras[3])

proc radula_behave_stage*(name, version, stage = RADULA_DIRECTORY_SYSTEM, log_file: string): (string, int) =
    # We only use `nom` and `ver` from the `ceras`file
    #
    # All phases need to be called sequentially to prevent the loss of the
    # current working directory...
    execCmdEx(RADULA_CERAS_DASH & ' ' & RADULA_TOOTH_SHELL_FLAGS & ' ' & (&"nom={name} ver={version} . {RADULA_PATH_RADULA_CLUSTERS}/{RADULA_DIRECTORY_GLAUCUS}/{name}/{stage} && prepare $1 && configure $1 && build $1 && check $1 && install $1" % [&">> {log_file} 2>&1"]).quoteShell)

proc radula_behave_envenomate*(names: openArray[string], stage: string = RADULA_DIRECTORY_SYSTEM, resolve: bool = true) =
    var
        log_file: string

        names = names.deduplicate()

        concentrates: Table[string, seq[string]]

        length: int

    for name in names:
        if not radula_behave_ceras_exist(name):
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:48}{\"nom\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            radula_behave_exit(1)

        if resolve:
            radula_behave_ceras_concentrates_resolve(name, concentrates)

    if resolve:
        names = toposort(concentrates)

    length = names.len()

    echo &"Swallow {length} cerata..."

    radula_behave_ceras_print_header()

    # Swallow cerata in parallel
    waitFor radula_behave_swallow(names)

    echo ""

    echo &"Envenomate {length} cerata..."

    radula_behave_ceras_print_header()

    for name in names:
        let
            ceras = radula_behave_ceras_parse(name)

            version =
                try:
                    ceras["ver"].getStr()
                except CatchableError:
                    ""
            commit =
                try:
                    ceras["cmt"].getStr()
                except CatchableError:
                    ""

        if version == "git":
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {name:24}{commit:24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle
        else:
            styledEcho fgMagenta, styleBright, &"{\"Envenomate\":13} :~ {name:24}{version:24}{\"phase\":13}{now().format(\"hh:mm:ss tt\")}", resetStyle

        case stage
        of RADULA_DIRECTORY_CROSS:
            log_file = getEnv(RADULA_ENVIRONMENT_FILE_CROSS_LOG)
        of RADULA_DIRECTORY_TOOLCHAIN:
            log_file = getEnv(RADULA_ENVIRONMENT_FILE_TOOLCHAIN_LOG)

        let output = radula_behave_stage(name, version, stage, log_file)

        cursorUp 1
        eraseLine()

        if output[1] != 0:
            styledEcho fgRed, styleBright, &"{\"Abort\":13} :! {name:48}{output[1]:<13}{now().format(\"hh:mm:ss tt\")}", resetStyle

            radula_behave_exit(1)

        if version == "git":
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{commit:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
        else:
            styledEcho fgGreen, &"{\"Envenomate\":13}", fgDefault, " :~ ", fgBlue, styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen, &"{\"complete\":13}", fgYellow, now().format("hh:mm:ss tt"), fgDefault
