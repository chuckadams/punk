ext_tidy_sources = files(
  'tidy.c',
)

# tidy's stupid pkgconf doesn't provide the include dir, and include_directories bombs if a dir doesn't exist
ext_tidy_extra_includes = run_command('sh', '-c', 'for d in /usr/include/tidy; do [ -d "$d" ] && echo $d; done', check : false).stdout().strip().split('\n')

shared_module(
    'tidy',
    [ext_tidy_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, ext_tidy_extra_includes],
    dependencies: [dependency('tidy')],
    install : true,
)
