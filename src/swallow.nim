# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import httpclient
import os
import sequtils
import streams
import strutils

import ceras

import hashlib/misc/xxhash
import parsetoml
import toposort

# Verifies `XXH3_128bits` checksum of source tarball
proc radula_behave_verify*(name: string, file: string, checksum: string): bool =
    checksum == $count[XXHASH3_128](newFileStream(joinPath(
            radula_behave_ceras_path_source(name), file), fmRead))

# Asynchronously swallow cerata
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var
        names = names.deduplicate()

        swallowed: seq[string]

        dependencies: Table[string, seq[string]]

        clones: seq[seq[string]]
        downloads: seq[(seq[string], Future[void])]

    for name in names:
        if not radula_behave_ceras_exist(name):
            echo "        skip  :! " & name & " invalid ceras"
            continue

        let
            ceras = radula_behave_ceras_parse(name)

            version = try: ceras["ver"].getStr() except: ""
            url = try: ceras["url"].getStr() except: ""

        if (url == ""):
            echo "        skip  :! " & name & " virtual ceras"
            continue
        # downloads &= (@[name, url, ceras["sum"].getStr()],
        #         newAsyncHttpClient().downloadFile(url, lastPathPart(url)))

        radula_behave_ceras_concentrates_resolve(name, dependencies)

        if dirExists(radula_behave_ceras_path_source(name)):
            swallowed &= name
            continue
        else:
            if version == "git":
                clones &= @[name, ceras["cmt"].getStr(), url]
            else:
                echo "    swallow   :< " & name & " " & version

                downloads &= (@[name, url, ceras["sum"].getStr()],
                        newAsyncHttpClient().downloadFile(url, lastPathPart(url)))

    # waitFor all(downloads.unzip()[1])

    echo toposort(dependencies)
    # use startprocesses for starting multiple git clones as well
    # loop over swallowed cerata and check if they are valid (checksums
