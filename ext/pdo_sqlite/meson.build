ext_pdo_sqlite_sources = files(
  'pdo_sqlite.c',
  'sqlite_driver.c',
  'sqlite_sql_parser.c',
  'sqlite_statement.c',
)

shared_module(
    'pdo_sqlite',
    [ext_pdo_sqlite_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)
