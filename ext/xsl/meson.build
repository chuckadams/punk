php_xsl_arginfo_gen = custom_target(
    'php_xsl_arginfo',
    input: 'php_xsl.stub.php',
    output: [ 'php_xsl_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_xsl_sources = files(
  'php_xsl.c',
  'xsltprocessor.c',
)

shared_module(
    'xsl',
    [ext_xsl_sources, php_xsl_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libxml-2.0'), dependency('libxslt'), dependency('libexslt')],
    install : true,
)
