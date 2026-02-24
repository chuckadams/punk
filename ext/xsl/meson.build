ext_xsl_sources = files(
  'php_xsl.c',
  'xsltprocessor.c',
)

shared_module(
    'xsl',
    [ext_xsl_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
