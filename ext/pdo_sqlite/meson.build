re2c = find_program('re2c')

sqlite_sql_parser_gen = custom_target(
    'sqlite_sql_parser',
    input: 'sqlite_sql_parser.re',
    output: 'sqlite_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

pdo_sqlite_arginfo_gen = custom_target(
    'pdo_sqlite_arginfo',
    input: 'pdo_sqlite.stub.php',
    output: [ 'pdo_sqlite_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

sqlite_driver_arginfo_gen = custom_target(
    'sqlite_driver_arginfo',
    input: 'sqlite_driver.stub.php',
    output: [ 'sqlite_driver_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_pdo_sqlite_sources = files(
  'pdo_sqlite.c',
  'sqlite_driver.c',
  'sqlite_statement.c',
) + [sqlite_sql_parser_gen[0]]

shared_module(
    'pdo_sqlite',
    [ext_pdo_sqlite_sources, pdo_sqlite_arginfo_gen[0], sqlite_driver_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('sqlite3')],
    install : true,
)
