tidy_arginfo_gen = custom_target(
    'tidy_arginfo',
    input: 'tidy.stub.php',
    output: [ 'tidy_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_tidy_sources = files(
  'tidy.c',
)

# tidy's stupid pkgconf doesn't provide the include dir, and include_directories bombs if a dir doesn't exist
ext_tidy_extra_includes = run_command('sh', '-c', 'for d in /usr/include/tidy; do [ -d "$d" ] && echo $d; done', check : false).stdout().strip().split('\n')

shared_module(
    'tidy',
    [ext_tidy_sources, tidy_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.', ext_tidy_extra_includes],
    dependencies: [dependency('tidy')],
    install : true,
)
