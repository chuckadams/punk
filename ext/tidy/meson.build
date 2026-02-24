ext_tidy_sources = files(
  'tidy.c',
)

shared_module(
    'tidy',
    [ext_tidy_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '/usr/include/tidy'],  # tidy's stupid pkgconf doesn't provide the include dir
    dependencies: [dependency('tidy')],
    install : true,
)
