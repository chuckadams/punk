exif_arginfo_gen = custom_target(
    'exif_arginfo',
    input: 'exif.stub.php',
    output: [ 'exif_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_exif_sources = files(
  'exif.c',
)

shared_module(
    'exif',
    [ext_exif_sources, exif_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    install : true,
)
