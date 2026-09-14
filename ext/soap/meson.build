ext_soap_sources = files(
  'php_encoding.c',
  'php_http.c',
  'php_packet_soap.c',
  'php_schema.c',
  'php_sdl.c',
  'php_xml.c',
  'soap.c',
)

soap_arginfo_gen = custom_target(
    'soap_arginfo',
    input: 'soap.stub.php',
    output: [ 'soap_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'soap',
    [ext_soap_sources, soap_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
