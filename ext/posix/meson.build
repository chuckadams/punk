ext_posix_sources = files(
  'posix.c',
)

posix_arginfo_gen = custom_target(
    'posix_arginfo',
    input: 'posix.stub.php',
    output: [ 'posix_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'posix',
    [ext_posix_sources, posix_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
