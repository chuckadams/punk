ftp_arginfo_gen = custom_target(
    'ftp_arginfo',
    input: 'ftp.stub.php',
    output: [ 'ftp_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_ftp_sources = files(
  'ftp.c',
  'php_ftp.c',
)

shared_module(
    'ftp',
    [ext_ftp_sources, ftp_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('openssl')],
    install : true,
)
