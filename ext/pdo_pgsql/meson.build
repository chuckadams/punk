ext_pdo_pgsql_sources = files(
  'pdo_pgsql.c',
  'pgsql_driver.c',
  'pgsql_sql_parser.c',
  'pgsql_statement.c',
)

shared_module(
    'pdo_pgsql',
    [ext_pdo_pgsql_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
)
