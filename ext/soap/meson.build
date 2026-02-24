ext_soap_sources = files(
  'php_encoding.c',
  'php_http.c',
  'php_packet_soap.c',
  'php_schema.c',
  'php_sdl.c',
  'php_xml.c',
  'soap.c',
)

shared_module(
    'soap',
    [ext_soap_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libxml-2.0')],
)
