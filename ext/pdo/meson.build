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

install_headers(
    'pdo_sql_parser.h',
    'php_pdo.h',
    'php_pdo_driver.h',
    'php_pdo_error.h',
    subdir: 'ext/pdo',
)
