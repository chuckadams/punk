gmp_arginfo_gen = custom_target(
    'gmp_arginfo',
    input: 'gmp.stub.php',
    output: [ 'gmp_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_gmp_sources = files(
    'gmp.c',
)

shared_module(
    'gmp',
    [ext_gmp_sources, gmp_arginfo_gen[0]],
    name_prefix : '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [dependency('gmp')],
    install : true,
)

install_headers(
    'php_gmp_int.h',
    subdir : 'php/ext/gmp',
)
