# Copyright (c) 2018-2023, Firas Khalil Khana
# Distributed under the terms of the ISC License

import os
import parsetoml

import constants

proc radula_behave_ceras_path*(name: string): string =
    joinPath(RADULA_PATH_RADULA_CLUSTERS, RADULA_DIRECTORY_GLAUCUS, name, RADULA_CERAS)

proc radula_behave_ceras_parse*(name: string): TomlValueRef =
    parseFile(radula_behave_ceras_path(name))

proc radula_behave_ceras_print*(names: seq[string]) =
    for name in names:
        let ceras = radula_behave_ceras_parse(name)
        echo "Name          :: ", ceras["nom"].getStr()
        echo "Version       :: ", try: ceras["ver"].getStr() except: "None",
                try: " " & ceras["cmt"].getStr() except: ""
        echo "URL           :: ", try: ceras["url"].getStr() except: "None"
        echo "Checksum      :: ", try: ceras["sum"].getStr() except: "None"
        echo "Concentrates  :: ", try: ceras["cnt"].getStr() except: "None"
        echo "Cysts         :: ", try: ceras["cys"].getStr() except: "None"
        echo ""
