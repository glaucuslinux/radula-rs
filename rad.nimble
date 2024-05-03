# Package
version      = "0.1.0"
author       = "Firas Khalil Khana <firasuke@glaucuslinux.org>"
description  = "glaucus's package manager"
license      = "ISC"

skipFiles    = @["LICENSE", "README.md"]
srcDir       = "src"

bin          = @["rad"]

# Deps
requires "hashlib >= 1.0.1"
requires "nim >= 2.0.4"
requires "parsetoml >= 0.7.1"
requires "toposort >= 1.0.0"
