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

phar_object_arginfo_gen = custom_target(
    'phar_object_arginfo',
    input: 'phar_object.stub.php',
    output: [ 'phar_object_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'phar',
    [ext_phar_sources, phar_object_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)

install_headers(
    'php_phar.h',
    subdir: 'php/ext/phar',
)
