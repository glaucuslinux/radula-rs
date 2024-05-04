# Copyright (c) 2018-2024, Firas Khalil Khana
# Distributed under the terms of the ISC License

import
  std/[os, parseopt],
  bootstrap, ceras, constants, genome, teeth

proc rad_options*() =
  if paramCount() < 1:
    echo RAD_HELP

    quit(QuitFailure)

  var p = initOptParser()

  p.next()

  case p.kind
  of cmdArgument, cmdEnd:
    echo RAD_HELP

    quit(QuitFailure)
  of cmdLongOption, cmdShortOption:
    # Catch `Ctrl-C` and exit gracefully
    setControlCHook(rad_interrupt)

    # Check lck file
    rad_lck()

    case p.key
    of "b", "bootstrap":
      p.next()

      case p.kind
      of cmdEnd:
        echo RAD_HELP_BOOTSTRAP

        rad_exit(QuitFailure)
      of cmdArgument, cmdLongOption, cmdShortOption:
        case p.key
        of "c", "clean":
          rad_bootstrap_env()
          rad_bootstrap_clean()

          echo "clean complete"
        of "d", "distclean":
          rad_bootstrap_env()
          rad_bootstrap_distclean()

          echo "distclean complete"
        of "h", "help":
          echo RAD_HELP_BOOTSTRAP
        of "i", "img":
          rad_bootstrap_env()
          rad_teeth_env()
          rad_bootstrap_release_img()

          echo "img complete"
        of "r", "release":
          rad_bootstrap_env()
          rad_teeth_env()
          rad_bootstrap_release_iso()

          echo "release complete"
        of "s", "system":
          rad_teeth_env()
          rad_genome_env(RAD_DIR_SYSTEM)
          rad_genome_flags_env()
          rad_bootstrap_system_env_dir()
          rad_bootstrap_system_env_pkg_config()
          rad_bootstrap_system_env_teeth()
          rad_bootstrap_system_prepare()
          rad_bootstrap_system_build()

          echo ""
          echo "system complete"
        of "t", "toolchain":
          rad_bootstrap_env()
          rad_teeth_env()
          rad_genome_env()
          rad_bootstrap_clean()
          rad_bootstrap_init()
          rad_bootstrap_toolchain_build()
          rad_bootstrap_toolchain_backup()

          echo ""
          echo "toolchain complete"
        of "x", "cross":
          rad_bootstrap_env()
          rad_teeth_env()
          rad_genome_env()
          rad_genome_flags_env()
          rad_bootstrap_cross_env_pkg_config()
          rad_bootstrap_cross_env_teeth()
          rad_bootstrap_cross_prepare()
          rad_bootstrap_cross_build()

          echo ""
          echo "cross complete"
        else:
          echo RAD_HELP_BOOTSTRAP

          rad_exit(QuitFailure)
    of "c", "ceras":
      p.next()

      case p.kind
      of cmdEnd:
        echo RAD_HELP_CERAS

        rad_exit(QuitFailure)
      of cmdArgument, cmdLongOption, cmdShortOption:
        case p.key
        of "a", "append":
          echo ""
          echo "append complete"
        of "b", "build":
          rad_teeth_env()
          rad_genome_env(RAD_DIR_SYSTEM)
          rad_genome_flags_env()
          rad_bootstrap_system_env_dir()
          rad_bootstrap_system_env_pkg_config()
          rad_bootstrap_system_env_teeth()
          rad_bootstrap_system_prepare()
          rad_ceras_build(remainingArgs(p))

          echo ""
          echo "build complete"
        of "c", "clean":
          rad_ceras_clean()

          echo "clean complete"
        of "d", "distclean":
          rad_ceras_distclean()

          echo "distclean complete"
        of "h", "help":
          echo RAD_HELP_CERAS
        of "i", "install":
          rad_ceras_install(remainingArgs(p))

          echo ""
          echo "install complete"
        of "l", "list":
          echo ""
          echo "list complete"
        of "n", "new":
          echo ""
          echo "new complete"
        of "p", "print":
          rad_ceras_print(remainingArgs(p))
        of "r", "remove":
          rad_ceras_remove(remainingArgs(p))

          echo ""
          echo "remove complete"
        of "s", "search":
          rad_ceras_search(remainingArgs(p))

          echo "search complete"
        of "u", "upgrade":
          echo ""
          echo "upgrade complete"
        of "y", "sync":
          echo ""
          echo "sync complete"
        else:
          echo RAD_HELP_CERAS

          rad_exit(QuitFailure)
    of "h", "help":
      echo RAD_HELP
    of "v", "version":
      echo RAD_HELP_VERSION
    else:
      echo RAD_HELP

      rad_exit(QuitFailure)

    rad_exit()
