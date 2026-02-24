ext_pgsql_sources = files(
  'pgsql.c',
)

shared_module(
    'pgsql',
    [ext_pgsql_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libpq')],
    install : true,
)
