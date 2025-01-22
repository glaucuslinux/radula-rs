# Copyright (c) 2018-2025, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[os, parseopt], arch, bootstrap, cerata, constants, tools

proc options*() =
  if paramCount() < 1:
    echo Rad

    quit(QuitFailure)

  var p = initOptParser()

  p.next()

  case p.kind
  of cmdArgument, cmdEnd:
    echo Rad

    quit(QuitFailure)
  of cmdLongOption, cmdShortOption:
    # Catch `Ctrl-C` and exit gracefully
    setControlCHook(interrupt)

    lock()

    case p.key
    of "b", "bootstrap":
      p.next()

      case p.kind
      of cmdEnd:
        echo Bootstrap

        exit(QuitFailure)
      of cmdArgument, cmdLongOption, cmdShortOption:
        case p.key
        of "c", "clean":
          setEnvBootstrap()
          cleanBootstrap()

          echo "clean complete"
        of "d", "distclean":
          setEnvBootstrap()
          distcleanBootstrap()

          echo "distclean complete"
        of "h", "help":
          echo Bootstrap
        of "n", "native":
          setEnvArch()
          setEnvNativeDirs()
          setEnvNativeTools()
          buildNative()

          echo ""
          echo "native complete"
        of "t", "toolchain":
          setEnvArch(toolchain)
          setEnvBootstrap()
          cleanBootstrap()
          initBootstrap()
          buildToolchain()

          echo ""
          echo "toolchain complete"
        of "x", "cross":
          setEnvArch(cross)
          setEnvBootstrap()
          setEnvCrossTools()
          prepareCross()
          buildCross()

          echo ""
          echo "cross complete"
        else:
          echo Bootstrap

          exit(QuitFailure)
    of "c", "cerata":
      p.next()

      case p.kind
      of cmdEnd:
        echo Cerata

        exit(QuitFailure)
      of cmdArgument, cmdLongOption, cmdShortOption:
        case p.key
        of "b", "build":
          setEnvArch()
          setEnvNativeDirs()
          setEnvNativeTools()
          cleanCerata()
          buildCerata(remainingArgs(p))

          echo ""
          echo "build complete"
        of "c", "clean":
          cleanCerata()

          echo "clean complete"
        of "d", "distclean":
          distcleanCerata()

          echo "distclean complete"
        of "h", "help":
          echo Cerata
        of "i", "install":
          installCerata(remainingArgs(p))

          echo ""
          echo "install complete"
        of "l", "list":
          listCerata()
        of "p", "print":
          printCerata(remainingArgs(p))
        of "r", "remove":
          removeCerata(remainingArgs(p))

          echo ""
          echo "remove complete"
        of "s", "search":
          searchCerata(remainingArgs(p))
        of "u", "upgrade":
          echo ""
          echo "upgrade complete"
        else:
          echo Cerata

          exit(QuitFailure)
    of "h", "help":
      echo Rad
    of "v", "version":
      echo version
    else:
      echo Rad

      exit(QuitFailure)

    exit()
