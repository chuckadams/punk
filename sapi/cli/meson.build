sapi_cli_sources = files(
    'php_cli.c',
    'php_cli_process_title.c',
    'php_cli_server.c',
    'php_http_parser.c',
    'ps_title.c',
)

sapi_cli_all_sources = [
    main_sources,
    tsrm_sources,
    sapi_cli_sources,
    ext_date_sources,
    ext_json_sources,
    ext_lexbor_sources,
    ext_libxml_sources,
    ext_mysqli_sources,
    ext_mysqlnd_sources,
    ext_opcache_sources,
    ext_readline_sources,
    ext_random_sources,
    ext_reflection_sources,
    ext_spl_sources,
    ext_standard_sources,
    ext_uri_sources,
]

sapi_cli_dependencies = [
    dependency('icu-i18n'),
    dependency('icu-io'),
    dependency('libargon2'),
    dependency('libavif'), # needed because of ext/standard/image.c
    dependency('libedit'),
    dependency('libxml-2.0'),
    dependency('openssl'),
    dependency('threads'),
    dependency('zlib'),
    cc.find_library('m'),
]

sapi_cli_exe = executable(
    'punk',
    sapi_cli_all_sources,
    dependencies : sapi_cli_dependencies,
    include_directories : includes,
    link_whole : [zend_objs, ext_hash_objs, ext_intl_objs, ext_pcre_objs],
    export_dynamic : true,
    install : true,
)

test('sapi_cli_test_basic', sapi_cli_exe)

install_headers(
    'cli.h',
    subdir : 'sapi/cli',
)
