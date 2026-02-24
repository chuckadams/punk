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
    name_prefix: '',
    c_args: [],
    include_directories : [includes],
    install : true,
)
