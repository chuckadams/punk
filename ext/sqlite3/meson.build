sqlite3_arginfo_gen = custom_target(
    'sqlite3_arginfo',
    input: 'sqlite3.stub.php',
    output: [ 'sqlite3_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_sqlite3_sources = files(
  'sqlite3.c',
)

shared_module(
    'sqlite3',
    [ext_sqlite3_sources, sqlite3_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('sqlite3')],
    install : true,
)
