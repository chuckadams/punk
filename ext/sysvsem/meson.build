sysvsem_arginfo_gen = custom_target(
    'sysvsem_arginfo',
    input: 'sysvsem.stub.php',
    output: [ 'sysvsem_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_sysvsem_sources = files(
  'sysvsem.c',
)

shared_module(
    'sysvsem',
    [ext_sysvsem_sources, sysvsem_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
