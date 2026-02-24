ext_phar_sources = files(
  'dirstream.c',
  'func_interceptors.c',
  'phar.c',
  'phar_object.c',
  'phar_path_check.c',
  'stream.c',
  'tar.c',
  'util.c',
  'zip.c',
)

shared_module(
    'phar',
    [ext_phar_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
)
