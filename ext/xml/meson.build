ext_xml_sources = files(
  'compat.c',
  'xml.c',
)

shared_module(
    'xml',
    [ext_xml_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libxml-2.0')],
)
