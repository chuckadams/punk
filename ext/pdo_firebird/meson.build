pdo_firebird_arginfo_gen = custom_target(
    'pdo_firebird_arginfo',
    input: 'pdo_firebird.stub.php',
    output: [ 'pdo_firebird_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_pdo_firebird_sources = files(
  'firebird_driver.c',
  'firebird_statement.c',
  'pdo_firebird.c',
  'pdo_firebird_utils.cpp',
)

shared_module(
    'pdo_firebird',
    [ext_pdo_firebird_sources, pdo_firebird_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    # firebird ships fb_config rather than a pkg-config file
    dependencies: [cc.find_library('fbclient')],
    install : true,
)
