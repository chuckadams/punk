sysvshm_arginfo_gen = custom_target(
    'sysvshm_arginfo',
    input: 'sysvshm.stub.php',
    output: [ 'sysvshm_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_sysvshm_sources = files(
  'sysvshm.c',
)

shared_module(
    'sysvshm',
    [ext_sysvshm_sources, sysvshm_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
