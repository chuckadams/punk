ext_pgsql_sources = files(
  'pgsql.c',
)

pgsql_arginfo_gen = custom_target(
    'pgsql_arginfo',
    input: 'pgsql.stub.php',
    output: [ 'pgsql_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'pgsql',
    [ext_pgsql_sources, pgsql_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libpq')],
    install : true,
)
