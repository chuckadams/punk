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
    zend_sources,
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

link_whole = [ext_hash_objs, ext_intl_objs, ext_pcre_objs]

cli = executable(
    'punk',
    sapi_cli_all_sources,
    dependencies : dependencies,
    include_directories : includes,
    link_whole: link_whole,
    install : false,
)

#test('test_cli_basic', cli)

