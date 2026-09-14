sapi_cgi_sources = files(
    'cgi_main.c',
)

cgi_main_arginfo_gen = custom_target('cgi_main_arginfo', input: 'cgi_main.stub.php', output: 'cgi_main_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

# The CGI SAPI is what run-tests.php drives for --POST--/--GET--/--COOKIE-- and
# --CGI-- tests, so the full suite (`just test-installed`) needs an installed
# php-cgi alongside the CLI.
sapi_cgi_exe = executable(
    'php-cgi',
    # ext/standard/basic_functions.c includes <zend_language_parser.h> and
    # ext/opcache includes zend_vm_opcodes.h, both generated in Zend/; listing
    # them as sources orders the generators before this target compiles.
    [punk_frontend_sources, sapi_cgi_sources, zend_language_parser_gen[1], zend_vm_gen[0],
     cgi_main_arginfo_gen[0], punk_frontend_arginfo],
    c_args : static_c_args,
    dependencies : punk_frontend_dependencies,
    include_directories : [includes, '.'],
    link_whole : punk_frontend_link_whole,
    export_dynamic : true,
    install : true,
)

# The one man page punk ships.  php.1 documents a binary named php and phpize.1 a
# tool punk does not carry; phar's pages describe a CLI this install does not
# include.  The template has no substitutions, so this is a copy.
install_man(configure_file(input : 'php-cgi.1.in', output : 'php-cgi.1', copy : true))
