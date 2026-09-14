xml_arginfo_gen = custom_target(
    'xml_arginfo',
    input: 'xml.stub.php',
    output: [ 'xml_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_xml_sources = files(
    'compat.c',
    'xml.c',
)

shared_module(
    'xml',
    [ext_xml_sources, xml_arginfo_gen[0]],
    name_prefix : '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [dependency('libxml-2.0')],
    install : true,
)

install_headers(
    'expat_compat.h',
    'php_xml.h',
    subdir : 'php/ext/xml',
)
