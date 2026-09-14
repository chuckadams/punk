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
        c_args : [],
        include_directories : [includes],
        dependencies: [dependency('libxml-2.0')],
        install : true,
    )
endif

install_headers(
    'php_libxml.h',
    subdir: 'ext/libxml',
)
