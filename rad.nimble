version = "0.1.0"
author = "Firas Khalil Khana <firasuke@glaucuslinux.org>"
description = "glaucus package manager"
license = "ISC"

skipFiles = @["LICENSE", "README.md"]
srcDir = "src"

bin = @["rad"]

requires "hashlib >= 1.0.1"
requires "nim >= 2.2.0"
requires "tomlSerialization >= 0.2.12"
requires "toposort >= 1.0.0"
