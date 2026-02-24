ext_pdo_dblib_sources = files(
  'dblib_driver.c',
  'dblib_stmt.c',
  'pdo_dblib.c',
)

shared_module(
    'pdo_dblib',
    [ext_pdo_dblib_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)
