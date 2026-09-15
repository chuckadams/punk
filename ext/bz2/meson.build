bz2_arginfo_gen = custom_target(
    'bz2_arginfo',
    input: 'bz2.stub.php',
    output: [ 'bz2_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_bz2_sources = files(
  'bz2.c',
  'bz2_filter.c',
)

shared_module(
    'bz2',
    [ext_bz2_sources, bz2_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [dependency('bzip2')],
    install : true,
)
