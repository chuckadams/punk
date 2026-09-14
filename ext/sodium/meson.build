ext_sodium_sources = files(
  'libsodium.c',
  'sodium_pwhash.c',
)

shared_module(
    'sodium',
    [ext_sodium_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libsodium')],
    install : true,
)

install_headers(
    'php_libsodium.h',
    subdir: 'php/ext/sodium',
)