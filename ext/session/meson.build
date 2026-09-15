ext_session_sources = files(
  'mod_files.c',
  'mod_mm.c',
  'mod_user.c',
  'mod_user_class.c',
  'session.c',
)

session_arginfo_gen = custom_target(
    'session_arginfo',
    input: 'session.stub.php',
    output: [ 'session_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'session',
    [ext_session_sources, session_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)

install_headers(
    'mod_files.h',
    'mod_user.h',
    'php_session.h',
    subdir: 'php/ext/session',
)
