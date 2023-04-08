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
    terminal
]

import
    ceras,
    constants

import
    hashlib/misc/blake3,
    parsetoml

# Clone repositories
proc radula_behave_clone*(commit, url, path: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_GIT} {RADULA_TOOTH_GIT_CHECKOUT_FLAGS} {commit}",
        workingDir = path)

# Extract tarballs
proc radula_behave_extract*(file, path: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {file} -C {path}")

# Verify `BLAKE3` checksum of source tarball
proc radula_behave_verify*(file, checksum: string): bool =
    $count[BLAKE3](readFile(file)) == checksum

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        clones: seq[(seq[string], string)]
        downloads: seq[(seq[string], Future[void])]
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
            styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue,
                styleBright, &"{name:24}", resetStyle, &"{version:24}",
                fgGreen, "complete", resetStyle

            continue

        let path = radula_behave_ceras_path_source(name)

        if dirExists(path):
            if version == "git":
                let commit = ceras["cmt"].getStr()

                styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ",
                    fgBlue, styleBright, &"{name:24}", resetStyle,
                    &"{commit:24}", fgGreen, "complete", fgDefault

                continue
            else:
                styledEcho fgMagenta, styleBright, &"{\"Swallow\":13}",
                    fgDefault, " :@ ", fgBlue, &"{name:24}", fgDefault,
                    &"{version:24}", fgMagenta, "verify", resetStyle

                if radula_behave_verify(path / lastPathPart(url), ceras[
                    "sum"].getStr()):
                    cursorUp 1
                    eraseLine()

                    styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ",
                        fgBlue, styleBright, &"{name:24}", resetStyle,
                        &"{version:24}", fgGreen, "complete", resetStyle

                    continue
                else:
                    styledEcho fgRed, styleBright,
                        &"{\"Abort\":13} :! {name:24}{version:24}invalid checksum", resetStyle

                    quit(1)
        else:
            if version == "git":
                let commit = ceras["cmt"].getStr()

                clones &= (@[name, commit, path],
                    &"{RADULA_TOOTH_GIT} {RADULA_TOOTH_GIT_CLONE_FLAGS} {url} {path}")
            else:
                createDir(path)

                downloads &= (@[name, version, url, ceras["sum"].getStr()],
                    newAsyncHttpClient().downloadFile(url, path /
                    lastPathPart(url)))

    length = downloads.unzip()[0].len()

    if length > 0:
        echo ""

        echo &"Download {length} cerata..."

        radula_behave_ceras_print_header()

        for ceras in downloads.unzip()[0]:
            let
                name = ceras[0]
                version = ceras[1]
            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13}", fgDefault,
                " :@ ", fgBlue, &"{name:24}", fgDefault, &"{version:24}",
                fgMagenta, "download", resetStyle

    waitFor all(downloads.unzip()[1])

    echo ""

    echo "Verify and extract cerata..."

    radula_behave_ceras_print_header()

    for ceras in downloads.unzip()[0]:
        let
            name = ceras[0]
            version = ceras[1]
            url = ceras[2]
            checksum = ceras[3]

            path = radula_behave_ceras_path_source(name)
            file = path / lastPathPart(url)

        styledEcho fgMagenta, styleBright, &"{\"Swallow\":13}", fgDefault,
            " :@ ", fgBlue, &"{name:24}", fgDefault, &"{version:24}",
            fgMagenta, "verify", resetStyle

        if radula_behave_verify(file, checksum):
            cursorUp 1
            eraseLine()

            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13}", fgDefault,
                " :@ ", fgBlue, &"{name:24}", fgDefault, &"{version:24}",
                fgMagenta, "extract", resetStyle

            discard radula_behave_extract(file, path)
        else:
            styledEcho fgRed, styleBright,
                &"{\"Abort\":13} :! {name:24}{version:24}invalid checksum", resetStyle

            quit(1)

        cursorUp 1
        eraseLine()

        styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue,
            styleBright, &"{name:24}", resetStyle, &"{version:24}", fgGreen,
            "complete", resetStyle

    length = clones.len()

    if length > 0:
        echo ""

        echo &"Clone {length} cerata..."

        radula_behave_ceras_print_header()

        echo "clones are ", clones

        echo ""
        echo "clones unzip are ", clones.unzip()[1]

        for ceras in clones.unzip[0]:
            let
                name = ceras[0]
                commit = ceras[1]
                path = ceras[2]

            styledEcho fgMagenta, styleBright, &"{\"Swallow\":13}", fgDefault,
                " :@ ", fgBlue, &"{name:24}", fgDefault, &"{commit:24}",
                fgMagenta, "clone", resetStyle

        # execProcesses()
