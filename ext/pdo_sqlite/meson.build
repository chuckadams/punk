re2c = find_program('re2c')

sqlite_sql_parser_gen = custom_target(
    'sqlite_sql_parser',
    input: 'sqlite_sql_parser.re',
    output: 'sqlite_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

ext_pdo_sqlite_sources = files(
  'pdo_sqlite.c',
  'sqlite_driver.c',
  'sqlite_statement.c',
) + [sqlite_sql_parser_gen[0]]

shared_module(
    'pdo_sqlite',
    [ext_pdo_sqlite_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('sqlite3')],
    install : true,
)
