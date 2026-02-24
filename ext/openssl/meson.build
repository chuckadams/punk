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
    [ext_openssl_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)
