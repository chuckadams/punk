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
    install : true,
)

install_headers(
    'php_curl.h',
    subdir: 'ext/curl',
)
