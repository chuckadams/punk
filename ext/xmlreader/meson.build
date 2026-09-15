php_xmlreader_arginfo_gen = custom_target(
    'php_xmlreader_arginfo',
    input: 'php_xmlreader.stub.php',
    output: [ 'php_xmlreader_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_xmlreader_sources = files(
  'php_xmlreader.c',
)

shared_module(
    'xmlreader',
    [ext_xmlreader_sources, php_xmlreader_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
