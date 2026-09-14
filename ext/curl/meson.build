ext_curl_sources = files(
  'curl_file.c',
  'interface.c',
  'multi.c',
  'share.c',
)

shared_module(
    'curl',
    [ext_curl_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies : [dependency('libcurl')],
    install : true,
)

install_headers(
    'php_curl.h',
    subdir: 'php/ext/curl',
)
