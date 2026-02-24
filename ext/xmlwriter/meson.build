ext_xmlwriter_sources = files(
  'php_xmlwriter.c',
)

shared_module(
    'xmlwriter',
    [ext_xmlwriter_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
