--define:danger
--define:lto
--define:release
--define:useMalloc
--define:ssl
--define:strip
--threads:on
--opt:speed
--mm:orc

when findExe("mold").len > 0 and defined(linux):
    switch("passL", "-fuse-ld=mold")