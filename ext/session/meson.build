ext_session_sources = files(
  'mod_files.c',
  'mod_mm.c',
  'mod_user.c',
  'mod_user_class.c',
  'session.c',
)

shared_module(
    'session',
    [ext_session_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)
