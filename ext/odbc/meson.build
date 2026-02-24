ext_odbc_sources = files(
  'odbc_utils.c',
  'php_odbc.c',
)

shared_module(
    'odbc',
    [ext_odbc_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
)
