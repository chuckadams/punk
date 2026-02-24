ext_spl_sources = files(
    'php_spl.c',
    'spl_array.c',
    'spl_directory.c',
    'spl_dllist.c',
    'spl_exceptions.c',
    'spl_fixedarray.c',
    'spl_functions.c',
    'spl_heap.c',
    'spl_iterators.c',
    'spl_observer.c',
)

shared_module(
    'spl',
    [ext_spl_sources],
    name_prefix : '',
    c_args : [],
    include_directories : [includes],
    install : true,
)

install_headers(
    'php_spl.h',
    'spl_array.h',
    'spl_directory.h',
    'spl_dllist.h',
    'spl_exceptions.h',
    'spl_fixedarray.h',
    'spl_functions.h',
    'spl_heap.h',
    'spl_iterators.h',
    'spl_observer.h',
    subdir : 'ext/spl',
)
