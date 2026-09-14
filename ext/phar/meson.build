re2c = find_program('re2c')

phar_path_check_gen = custom_target(
    'phar_path_check',
    input: 'phar_path_check.re',
    output: 'phar_path_check.c',
    command: [re2c, '--no-generation-date', '-W', '-g', '-b', '-o', '@OUTPUT@', '@INPUT@'],
)

ext_phar_sources = files(
  'dirstream.c',
  'func_interceptors.c',
  'phar.c',
  'phar_object.c',
  'stream.c',
  'tar.c',
  'util.c',
  'zip.c',
) + [phar_path_check_gen[0]]

shared_module(
    'phar',
    [ext_phar_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)

install_headers(
    'php_phar.h',
    subdir: 'php/ext/phar',
)
