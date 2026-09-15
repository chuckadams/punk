sysvmsg_arginfo_gen = custom_target(
    'sysvmsg_arginfo',
    input: 'sysvmsg.stub.php',
    output: [ 'sysvmsg_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_sysvmsg_sources = files(
  'sysvmsg.c',
)

shared_module(
    'sysvmsg',
    [ext_sysvmsg_sources, sysvmsg_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
