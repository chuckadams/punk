re2c = find_program('re2c')

pdo_sql_parser_gen = custom_target(
    'pdo_sql_parser',
    input: 'pdo_sql_parser.re',
    output: 'pdo_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

ext_pdo_sources = files(
  'pdo.c',
  'pdo_dbh.c',
  'pdo_sqlstate.c',
  'pdo_stmt.c',
) + [pdo_sql_parser_gen[0]]

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
    subdir: 'php/ext/pdo',
)
