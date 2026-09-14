re2c = find_program('re2c')

pgsql_sql_parser_gen = custom_target(
    'pgsql_sql_parser',
    input: 'pgsql_sql_parser.re',
    output: 'pgsql_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

ext_pdo_pgsql_sources = files(
  'pdo_pgsql.c',
  'pgsql_driver.c',
  'pgsql_statement.c',
) + [pgsql_sql_parser_gen[0]]

shared_module(
    'pdo_pgsql',
    [ext_pdo_pgsql_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libpq')],
    install : true,
)
