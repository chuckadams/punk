curl_arginfo_gen = custom_target(
    'curl_arginfo',
    input: 'curl.stub.php',
    output: 'curl_arginfo.h',
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

curl_file_arginfo_gen = custom_target(
    'curl_file_arginfo',
    input: 'curl_file.stub.php',
    output: 'curl_file_arginfo.h',
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_curl_sources = files(
  'curl_file.c',
  'interface.c',
  'multi.c',
  'share.c',
)

shared_module(
    'curl',
    # the generated headers are listed so ninja builds them before compiling the
    # sources that #include them
    [ext_curl_sources, curl_arginfo_gen[0], curl_file_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [dependency('libcurl')],
    install : true,
)

install_headers(
    'php_curl.h',
    subdir: 'php/ext/curl',
)
