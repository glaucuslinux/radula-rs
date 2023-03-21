# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import asyncdispatch
import httpclient
import os
import streams
import strutils

import ceras

import hashlib/misc/xxhash
import parsetoml

# Asynchronously download source tarballs
proc radula_behave_swallow*(names: seq[string]) {.async.} =
    var futures = newSeq[Future[void]](names.len)

    for i, name in names:
        let ceras = radula_behave_ceras_parse(name)

        let version = try: ceras["ver"].getStr() except: ""
        let commit = try: ceras["cmt"].getStr() except: ""
        let url = try: ceras["url"].getStr() except: ""

        echo "    swallow  :< " & (name & " " & version & " " & commit).strip()

        futures[i] = newAsyncHttpClient().downloadFile(url, lastPathPart(url))

    await all(futures)

# Verifies `XXH3_128bits` checksum of source tarball
proc radula_behave_verify*(name: string, file: string, checksum: string): bool =
    checksum == $count[XXHASH3_128](newFileStream(joinPath(
            radula_behave_ceras_path_source(name), file), fmRead))
