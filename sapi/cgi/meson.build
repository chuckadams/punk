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
