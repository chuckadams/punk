ext_pdo_sources = files(
  'pdo.c',
  'pdo_dbh.c',
  'pdo_sql_parser.c',
  'pdo_sqlstate.c',
  'pdo_stmt.c',
)

shared_module(
    'pdo',
    [ext_pdo_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)
