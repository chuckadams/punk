ext_simplexml_sources = files(
    'simplexml.c',
)

simplexml_arginfo_gen = custom_target(
    'simplexml_arginfo',
    input: 'simplexml.stub.php',
    output: [ 'simplexml_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'simplexml',
    [ext_simplexml_sources, simplexml_arginfo_gen[0]],
    name_prefix : '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [dependency('libxml-2.0')],
    install : true,
)

install_headers(
    'php_simplexml.h',
    'php_simplexml_exports.h',
    subdir : 'php/ext/simplexml',
)