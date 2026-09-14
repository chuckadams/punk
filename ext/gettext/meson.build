gettext_arginfo_gen = custom_target(
    'gettext_arginfo',
    input: 'gettext.stub.php',
    output: [ 'gettext_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_gettext_sources = files(
  'gettext.c',
)

shared_module(
    'gettext',
    [ext_gettext_sources, gettext_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
