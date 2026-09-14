ext_readline_sources = files(
    'readline.c',
    'readline_cli.c',
)

if not cli_static_extensions.contains('readline')
    shared_module(
        'readline',
        [ext_readline_sources],
        name_prefix: '',
        c_args: [],
        include_directories : [includes],
        install : true,
    )
endif
