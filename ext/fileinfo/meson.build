fileinfo_arginfo_gen = custom_target(
    'fileinfo_arginfo',
    input: 'fileinfo.stub.php',
    output: [ 'fileinfo_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_fileinfo_sources = files(
#  'data_file.c',
  'fileinfo.c',
  'libmagic/apprentice.c',
  'libmagic/apptype.c',
  'libmagic/ascmagic.c',
  'libmagic/buffer.c',
  'libmagic/cdf.c',
  'libmagic/cdf_time.c',
  'libmagic/compress.c',
  'libmagic/der.c',
  'libmagic/encoding.c',
  'libmagic/fsmagic.c',
  'libmagic/funcs.c',
  'libmagic/is_csv.c',
  'libmagic/is_json.c',
  'libmagic/is_simh.c',
  'libmagic/is_tar.c',
  'libmagic/magic.c',
  'libmagic/print.c',
  'libmagic/readcdf.c',
  'libmagic/softmagic.c',
  'libmagic/strcasestr.c',
  'php_libmagic.c',
)

shared_module(
    'fileinfo',
    [ext_fileinfo_sources, fileinfo_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libpcre2-8')],
    install : true,
)
