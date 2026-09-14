sapi_cli_sources = files(
    'php_cli.c',
    'php_cli_main.c',
    'php_cli_process_title.c',
    'php_cli_server.c',
    'php_http_parser.c',
    'ps_title.c',
)

sapi_cli_exe = executable(
    'punk',
    # ext/standard/basic_functions.c includes <zend_language_parser.h>, generated
    # in Zend/; listing it as a source orders the generator first.
    [punk_frontend_sources, sapi_cli_sources, zend_language_parser_gen[1]],
    c_args : static_c_args,
    dependencies : punk_frontend_dependencies,
    include_directories : includes,
    link_whole : punk_frontend_link_whole,
    export_dynamic : true,
    install : true,
)

test('sapi_cli_test_basic', sapi_cli_exe)

install_headers(
    'cli.h',
    subdir : 'php/sapi/cli',
)
