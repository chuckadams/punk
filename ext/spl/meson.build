php_spl_arginfo_gen = custom_target('php_spl_arginfo', input: 'php_spl.stub.php', output: 'php_spl_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_array_arginfo_gen = custom_target('spl_array_arginfo', input: 'spl_array.stub.php', output: 'spl_array_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_directory_arginfo_gen = custom_target('spl_directory_arginfo', input: 'spl_directory.stub.php', output: 'spl_directory_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_dllist_arginfo_gen = custom_target('spl_dllist_arginfo', input: 'spl_dllist.stub.php', output: 'spl_dllist_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_exceptions_arginfo_gen = custom_target('spl_exceptions_arginfo', input: 'spl_exceptions.stub.php', output: 'spl_exceptions_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_fixedarray_arginfo_gen = custom_target('spl_fixedarray_arginfo', input: 'spl_fixedarray.stub.php', output: 'spl_fixedarray_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_heap_arginfo_gen = custom_target('spl_heap_arginfo', input: 'spl_heap.stub.php', output: 'spl_heap_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_iterators_arginfo_gen = custom_target('spl_iterators_arginfo', input: 'spl_iterators.stub.php', output: 'spl_iterators_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
spl_observer_arginfo_gen = custom_target('spl_observer_arginfo', input: 'spl_observer.stub.php', output: 'spl_observer_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

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

if not cli_static_extensions.contains('spl')
    shared_module(
        'spl',
        [ext_spl_sources],
        name_prefix : '',
        c_args : [],
        include_directories : [includes],
        install : true,
    )
endif

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
    subdir : 'php/ext/spl',
)
