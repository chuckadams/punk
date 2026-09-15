libxml_arginfo_gen = custom_target('libxml_arginfo', input: 'libxml.stub.php', output: 'libxml_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

ext_libxml_sources = files(
    'image_svg.c',
    'libxml.c',
    'mime_sniff.c',
)

if not cli_static_extensions.contains('libxml')
    shared_module(
        'libxml',
        [ext_libxml_sources],
        name_prefix: '',
        name_suffix: 'so',
        c_args : [],
        include_directories : [includes],
        dependencies: [dependency('libxml-2.0')],
        install : true,
    )
endif

install_headers(
    'php_libxml.h',
    subdir: 'php/ext/libxml',
)
