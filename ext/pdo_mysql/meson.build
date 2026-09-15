re2c = find_program('re2c')

mysql_sql_parser_gen = custom_target(
    'mysql_sql_parser',
    input: 'mysql_sql_parser.re',
    output: 'mysql_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

pdo_mysql_arginfo_gen = custom_target(
    'pdo_mysql_arginfo',
    input: 'pdo_mysql.stub.php',
    output: [ 'pdo_mysql_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_pdo_mysql_sources = files(
  'mysql_driver.c',
  'mysql_statement.c',
  'pdo_mysql.c',
) + [mysql_sql_parser_gen[0]]

shared_module(
    'pdo_mysql',
    [ext_pdo_mysql_sources, pdo_mysql_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
