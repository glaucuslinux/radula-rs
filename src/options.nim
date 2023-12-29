# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import std/[
  os,
  parseopt
]

import
  bootstrap,
  ceras,
  constants,
  genome,
  teeth

proc radula_options*() =
  if paramCount() < 1:
    echo RADULA_HELP

    quit(QuitFailure)

  var p = initOptParser()

  p.next()

  case p.kind
  of cmdArgument, cmdEnd:
    echo RADULA_HELP

    quit(QuitFailure)
  of cmdLongOption, cmdShortOption:
    # Catch `Ctrl-C` and exit gracefully
    setControlCHook(radula_abort)

    # Check lock file
    radula_lock()

    case p.key
    of "b", "bootstrap":
      p.next()

      case p.kind
      of cmdEnd:
        echo RADULA_HELP_BOOTSTRAP

        radula_exit(QuitFailure)
      of cmdArgument, cmdLongOption, cmdShortOption:
        case p.key
        of "c", "clean":
          radula_bootstrap_environment()
          radula_bootstrap_toolchain_environment_directories()
          radula_bootstrap_cross_environment_directories()

          radula_bootstrap_clean()

          echo "clean complete"
        of "d", "distclean":
          radula_bootstrap_environment()
          radula_bootstrap_toolchain_environment_directories()
          radula_bootstrap_cross_environment_directories()

          radula_bootstrap_distclean()

          echo "distclean complete"
        of "h", "help":
          echo RADULA_HELP_BOOTSTRAP
        of "i", "img":
          radula_bootstrap_environment()

          radula_teeth_environment()

          radula_bootstrap_cross_release_img()

          echo "img complete"
        of "r", "release":
          radula_bootstrap_environment()

          radula_teeth_environment()

          radula_bootstrap_release_iso()

          echo "release complete"
        of "s", "system":
          radula_teeth_environment()

          # Default to `x86-64`
          radula_genome_environment(RADULA_DIRECTORY_SYSTEM)

          radula_flags_environment()

          radula_bootstrap_system_environment_directories()
          radula_bootstrap_system_environment_pkg_config()
          radula_bootstrap_system_environment_teeth()

          radula_bootstrap_system_prepare()
          radula_bootstrap_system_envenomate()

          echo ""
          echo "system complete"
        of "t", "toolchain":
          radula_bootstrap_environment()

          radula_teeth_environment()

          # Default to `x86-64`
          radula_genome_environment()

          radula_bootstrap_toolchain_environment_directories()

          # Needed for clean to work
          radula_bootstrap_cross_environment_directories()

          radula_bootstrap_clean()

          radula_bootstrap_initialize()

          radula_bootstrap_toolchain_prepare()
          radula_bootstrap_toolchain_envenomate()
          radula_bootstrap_toolchain_backup()

          echo ""
          echo "toolchain complete"
        of "x", "cross":
          radula_bootstrap_environment()

          radula_teeth_environment()

          # Default to `x86-64`
          radula_genome_environment()

          radula_flags_environment()

          radula_bootstrap_cross_environment_directories()
          radula_bootstrap_cross_environment_pkg_config()
          radula_bootstrap_cross_environment_teeth()

          radula_bootstrap_cross_prepare()
          radula_bootstrap_cross_envenomate()
          radula_bootstrap_cross_backup()

          echo ""
          echo "cross complete"
        else:
          echo RADULA_HELP_BOOTSTRAP

          radula_exit(QuitFailure)
    of "c", "ceras":
      p.next()

      let cerata = remainingArgs(p)

      case p.kind
      of cmdEnd:
        echo RADULA_HELP_CERAS

        radula_exit(QuitFailure)
      of cmdArgument, cmdLongOption, cmdShortOption:
        case p.key
        of "a", "add":
          echo ""
          echo "add complete"
        of "c", "clean":
          echo ""
          echo "clean complete"
        of "d", "distclean":
          echo ""
          echo "distclean complete"
        of "h", "help":
          echo RADULA_HELP_CERAS
        of "i", "install":
          echo ""
          echo "install complete"
        of "l", "list":
          echo ""
          echo "list complete"
        of "n", "new":
          echo ""
          echo "new complete"
        of "p", "print":
          radula_ceras_print(cerata)
        of "r", "remove":
          echo ""
          echo "remove complete"
        of "s", "search":
          echo ""
          echo "search complete"
        of "u", "upgrade":
          echo ""
          echo "upgrade complete"
        of "y", "sync":
          echo ""
          echo "sync complete"
        else:
          echo RADULA_HELP_CERAS

          radula_exit(QuitFailure)
    of "h", "help":
      echo RADULA_HELP
    of "v", "version":
      echo RADULA_HELP_VERSION
    else:
      echo RADULA_HELP

      radula_exit(QuitFailure)

    radula_exit()
