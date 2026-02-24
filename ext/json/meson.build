ext_json_sources = files(
    'json.c',
    'json_encoder.c',
    'json_parser.tab.c',
    'json_scanner.c',
)

shared_module(
    'json',
    [ext_json_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    install : true,
)

install_headers(
    'php_json.h',
    'php_json_parser.h',
    'php_json_scanner.h',
    subdir: 'ext/json',
)