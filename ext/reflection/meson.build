ext_reflection_sources = files(
    'php_reflection.c',
)

if not cli_static_extensions.contains('reflection')
    shared_module(
        'reflection',
        [ext_reflection_sources],
        name_prefix: '',
        c_args: [],
        include_directories : [includes],
        install : true,
    )
endif
