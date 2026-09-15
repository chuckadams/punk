ctype_arginfo_gen = custom_target(
    'ctype_arginfo',
    input: 'ctype.stub.php',
    output: [ 'ctype_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_ctype_sources = files(
  'ctype.c',
)

shared_module(
    'ctype',
    [ext_ctype_sources, ctype_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    install : true,
)
