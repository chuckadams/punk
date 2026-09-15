re2c = find_program('re2c')

pdo_sql_parser_gen = custom_target(
    'pdo_sql_parser',
    input: 'pdo_sql_parser.re',
    output: 'pdo_sql_parser.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-o', '@OUTPUT@', '@INPUT@'],
)

pdo_arginfo_gen = custom_target(
    'pdo_arginfo',
    input: 'pdo.stub.php',
    output: [ 'pdo_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

pdo_dbh_arginfo_gen = custom_target(
    'pdo_dbh_arginfo',
    input: 'pdo_dbh.stub.php',
    output: [ 'pdo_dbh_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

pdo_stmt_arginfo_gen = custom_target(
    'pdo_stmt_arginfo',
    input: 'pdo_stmt.stub.php',
    output: [ 'pdo_stmt_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_pdo_sources = files(
  'pdo.c',
  'pdo_dbh.c',
  'pdo_sqlstate.c',
  'pdo_stmt.c',
) + [pdo_sql_parser_gen[0]]

shared_module(
    'pdo',
    [ext_pdo_sources, pdo_arginfo_gen[0], pdo_dbh_arginfo_gen[0], pdo_stmt_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
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
