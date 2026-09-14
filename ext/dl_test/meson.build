dl_test_arginfo_gen = custom_target(
    'dl_test_arginfo',
    input: 'dl_test.stub.php',
    output: [ 'dl_test_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_dl_test_sources = files(
  'dl_test.c',
)

shared_module(
    'dl_test',
    [ext_dl_test_sources, dl_test_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    install : true,
)
