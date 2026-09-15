php_reflection_arginfo_gen = custom_target('php_reflection_arginfo', input: 'php_reflection.stub.php', output: ['php_reflection_arginfo.h', 'php_reflection_decl.h'], command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

ext_reflection_sources = files(
    'php_reflection.c',
)

if not cli_static_extensions.contains('reflection')
    shared_module(
        'reflection',
        [ext_reflection_sources],
        name_prefix: '',
        name_suffix: 'so',
        c_args: [],
        include_directories : [includes],
        install : true,
    )
endif
