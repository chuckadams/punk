enchant_arginfo_gen = custom_target(
    'enchant_arginfo',
    input: 'enchant.stub.php',
    output: [ 'enchant_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_enchant_sources = files(
  'enchant.c',
)

shared_module(
    'enchant',
    [ext_enchant_sources, enchant_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('enchant-2')],
    install : true,
)
