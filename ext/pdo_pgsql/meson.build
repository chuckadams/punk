re2c = find_program('re2c')

pgsql_sql_parser_gen = custom_target(
    'pgsql_sql_parser',
    input: 'pgsql_sql_parser.re',
    output: 'pgsql_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

pdo_pgsql_arginfo_gen = custom_target(
    'pdo_pgsql_arginfo',
    input: 'pdo_pgsql.stub.php',
    output: [ 'pdo_pgsql_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

pgsql_driver_arginfo_gen = custom_target(
    'pgsql_driver_arginfo',
    input: 'pgsql_driver.stub.php',
    output: [ 'pgsql_driver_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_pdo_pgsql_sources = files(
  'pdo_pgsql.c',
  'pgsql_driver.c',
  'pgsql_statement.c',
) + [pgsql_sql_parser_gen[0]]

shared_module(
    'pdo_pgsql',
    [ext_pdo_pgsql_sources, pdo_pgsql_arginfo_gen[0], pgsql_driver_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libpq')],
    install : true,
)
