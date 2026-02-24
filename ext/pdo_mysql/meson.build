ext_pdo_mysql_sources = files(
  'mysql_driver.c',
  'mysql_sql_parser.c',
  'mysql_statement.c',
  'pdo_mysql.c',
)

shared_module(
    'pdo_mysql',
    [ext_pdo_mysql_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
)
