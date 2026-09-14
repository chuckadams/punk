iconv_arginfo_gen = custom_target(
    'iconv_arginfo',
    input: 'iconv.stub.php',
    output: [ 'iconv_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_iconv_sources = files(
    'iconv.c',
)

shared_module(
    'iconv',
    [ext_iconv_sources, iconv_arginfo_gen[0]],
    name_prefix : '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [],
    install : true,
)

install_headers(
    'php_iconv.h',
    subdir : 'php/ext/iconv',
)
