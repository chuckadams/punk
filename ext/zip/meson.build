php_zip_arginfo_gen = custom_target(
    'php_zip_arginfo',
    input: 'php_zip.stub.php',
    output: [ 'php_zip_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_zip_sources = files(
  'php_zip.c',
  'zip_source.c',
  'zip_stream.c',
)

shared_module(
    'zip',
    [ext_zip_sources, php_zip_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libzip')],
    install : true,
)
