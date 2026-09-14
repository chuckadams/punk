ext_shmop_sources = files(
  'shmop.c',
)

shmop_arginfo_gen = custom_target(
    'shmop_arginfo',
    input: 'shmop.stub.php',
    output: [ 'shmop_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'shmop',
    [ext_shmop_sources, shmop_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
