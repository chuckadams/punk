ext_pdo_odbc_sources = files(
  'odbc_driver.c',
  'odbc_stmt.c',
  'pdo_odbc.c',
)

shared_module(
    'pdo_odbc',
    [ext_pdo_odbc_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libiodbc')],
)
