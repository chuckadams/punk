openssl_pwhash_arginfo_gen = custom_target(
    'openssl_pwhash_arginfo',
    input: 'openssl_pwhash.stub.php',
    output: [ 'openssl_pwhash_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

openssl_arginfo_gen = custom_target(
    'openssl_arginfo',
    input: 'openssl.stub.php',
    output: [ 'openssl_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_openssl_sources = files(
  'openssl.c',
  'openssl_backend_common.c',
  'openssl_backend_v1.c',
  'openssl_backend_v3.c',
  'openssl_pwhash.c',
  'xp_ssl.c',
)

shared_module(
    'openssl',
    [ext_openssl_sources, openssl_pwhash_arginfo_gen[0], openssl_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('openssl')],
    install : true,
)
