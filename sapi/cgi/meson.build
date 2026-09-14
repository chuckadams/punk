sapi_cgi_sources = files(
    'cgi_main.c',
)

# The CGI SAPI is what run-tests.php drives for --POST--/--GET--/--COOKIE-- and
# --CGI-- tests, so the full suite (`just test-installed`) needs an installed
# php-cgi alongside the CLI.
sapi_cgi_exe = executable(
    'php-cgi',
    [punk_frontend_sources, sapi_cgi_sources],
    c_args : static_c_args,
    dependencies : punk_frontend_dependencies,
    include_directories : includes,
    link_whole : punk_frontend_link_whole,
    export_dynamic : true,
    install : true,
)

# The one man page punk ships.  php.1 documents a binary named php and phpize.1 a
# tool punk does not carry; phar's pages describe a CLI this install does not
# include.  The template has no substitutions, so this is a copy.
install_man(configure_file(input : 'php-cgi.1.in', output : 'php-cgi.1', copy : true))
