sapi_cli_sources = files(
    'php_cli.c',
    'php_cli_main.c',
    'php_cli_process_title.c',
    'php_cli_server.c',
    'php_http_parser.c',
    'ps_title.c',
)

php_cli_process_title_arginfo_gen = custom_target('php_cli_process_title_arginfo', input: 'php_cli_process_title.stub.php', output: 'php_cli_process_title_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
php_cli_server_arginfo_gen = custom_target('php_cli_server_arginfo', input: 'php_cli_server.stub.php', output: 'php_cli_server_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

sapi_cli_exe = executable(
    'punk',
    # ext/standard/basic_functions.c includes <zend_language_parser.h> and
    # ext/opcache includes zend_vm_opcodes.h, both generated in Zend/; listing
    # them as sources orders the generators before this target compiles.
    [punk_frontend_sources, sapi_cli_sources, zend_language_parser_gen[1], zend_vm_gen[0],
     php_cli_process_title_arginfo_gen[0], php_cli_server_arginfo_gen[0], punk_frontend_arginfo],
    c_args : static_c_args,
    dependencies : punk_frontend_dependencies,
    include_directories : [includes, '.'],
    link_whole : punk_frontend_link_whole,
    export_dynamic : true,
    install : true,
)

test('sapi_cli_test_basic', sapi_cli_exe)

install_headers(
    'cli.h',
    subdir : 'php/sapi/cli',
)
