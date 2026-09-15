mysqli_arginfo_gen = custom_target('mysqli_arginfo', input: 'mysqli.stub.php', output: 'mysqli_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

ext_mysqli_sources = files(
    'mysqli.c',
    'mysqli_api.c',
    'mysqli_driver.c',
    'mysqli_exception.c',
    'mysqli_nonapi.c',
    'mysqli_prop.c',
    'mysqli_report.c',
    'mysqli_result_iterator.c',
    'mysqli_warning.c',
)

if not cli_static_extensions.contains('mysqli')
    shared_module(
        'mysqli',
        [ext_mysqli_sources],
        name_prefix : '',
        name_suffix: 'so',
        c_args : [],
        include_directories : [includes],
        install : true,
    )
endif

install_headers(
    'mysqli_mysqlnd.h',
    'php_mysqli_structs.h',
    subdir : 'php/ext/mysqli',
)
