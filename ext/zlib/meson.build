zlib_arginfo_gen = custom_target(
    'zlib_arginfo',
    input: 'zlib.stub.php',
    output: [ 'zlib_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_zlib_sources = files(
  'zlib.c',
  'zlib_filter.c',
  'zlib_fopen_wrapper.c',
)

shared_module(
    'zlib',
    [ext_zlib_sources, zlib_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
