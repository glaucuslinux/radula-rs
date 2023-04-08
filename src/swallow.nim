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

# Extract source tarballs
proc radula_behave_extract*(file, path: string): (string, int) =
    execCmdEx(&"{RADULA_TOOTH_TAR} {RADULA_TOOTH_TAR_EXTRACT_FLAGS} {file} -C {path}")

# Verify `BLAKE3` checksum of source tarball
proc radula_behave_verify*(file, checksum: string): bool =
    $count[BLAKE3](readFile(file)) == checksum

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        clones: seq[seq[string]]
        downloads: seq[(seq[string], Future[void])]

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
                styleBright, &"{name:24}", resetStyle, &"{\"virtual\":24}",
                fgGreen, "complete", fgDefault

            continue

        let path = radula_behave_ceras_path_source(name)

        if dirExists(path):
            if version == "git":
                styledEcho fgGreen, &"{\"Swallow\":13}", fgDefault, " :@ ",
                    fgBlue, styleBright, &"{name:24}", resetStyle,
                    &"{version:24}", fgGreen, "complete", fgDefault

                continue
            else:
                styledEcho fgMagenta, &"{\"Swallow\":13}", fgDefault, " :@ ",
                    fgBlue, styleBright, &"{name:24}", resetStyle,
                    &"{version:24}", fgMagenta, "verify", fgDefault

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
                clones &= @[name, ceras["cmt"].getStr(), url]
            else:
                styledEcho fgMagenta, &"{\"Swallow\":13}", fgDefault, " :@ ",
                    fgBlue, styleBright, &"{name:24}", resetStyle,
                    &"{version:24}", fgMagenta, "fetch", fgDefault

                createDir(path)

                downloads &= (@[name, version, url, ceras["sum"].getStr()],
                    newAsyncHttpClient().downloadFile(url, path / lastPathPart(url)))

    waitFor all(downloads.unzip()[1])

    for ceras in downloads.unzip()[0]:
        let
            name = ceras[0]
            version = ceras[1]
            url = ceras[2]
            checksum = ceras[3]

            path = radula_behave_ceras_path_source(name)
            file = path / lastPathPart(url)

        echo ""

        styledEcho fgMagenta, &"{\"Swallow\":13}", fgDefault, " :@ ", fgBlue,
            styleBright, &"{name:24}", resetStyle, &"{version:24}",
            fgMagenta, "verify", fgDefault

        if radula_behave_verify(file, checksum):
            cursorUp 1
            eraseLine()

            styledEcho fgMagenta, &"{\"Swallow\":13}", fgDefault, " :@ ",
                fgBlue, styleBright, &"{name:24}", resetStyle,
                &"{version:24}", fgMagenta, "extract", fgDefault

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

    # use startprocesses for starting multiple git clones as well
    # loop over swallowed cerata and check if they are valid (checksums
