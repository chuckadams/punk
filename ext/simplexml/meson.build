ext_simplexml_sources = files(
    'simplexml.c',
)

shared_module(
    'simplexml',
    [ext_simplexml_sources],
    name_prefix : '',
    c_args : [],
    include_directories : [includes],
    dependencies : [dependency('libxml-2.0')],
    install : true,
)

install_headers(
    'php_simplexml.h',
    'php_simplexml_exports.h',
    subdir : 'ext/simplexml',
)