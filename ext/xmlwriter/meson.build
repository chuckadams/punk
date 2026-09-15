php_xmlwriter_arginfo_gen = custom_target(
    'php_xmlwriter_arginfo',
    input: 'php_xmlwriter.stub.php',
    output: [ 'php_xmlwriter_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_xmlwriter_sources = files(
  'php_xmlwriter.c',
)

shared_module(
    'xmlwriter',
    [ext_xmlwriter_sources, php_xmlwriter_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
