libsodium_arginfo_gen = custom_target(
    'libsodium_arginfo',
    input: 'libsodium.stub.php',
    output: [ 'libsodium_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

sodium_pwhash_arginfo_gen = custom_target(
    'sodium_pwhash_arginfo',
    input: 'sodium_pwhash.stub.php',
    output: [ 'sodium_pwhash_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_sodium_sources = files(
  'libsodium.c',
  'sodium_pwhash.c',
)

shared_module(
    'sodium',
    [ext_sodium_sources, libsodium_arginfo_gen[0], sodium_pwhash_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libsodium')],
    install : true,
)

install_headers(
    'php_libsodium.h',
    subdir: 'php/ext/sodium',
)