opcache_arginfo_gen = custom_target('opcache_arginfo', input: 'opcache.stub.php', output: 'opcache_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

ext_opcache_sources = files(
    'ZendAccelerator.c',
    'shared_alloc_mmap.c',
    'shared_alloc_posix.c',
    'shared_alloc_shm.c',
    'zend_accelerator_api.c',
    'zend_accelerator_blacklist.c',
    'zend_accelerator_debug.c',
    'zend_accelerator_hash.c',
    'zend_accelerator_module.c',
    'zend_accelerator_util_funcs.c',
    'zend_file_cache.c',
    'zend_persist.c',
    'zend_persist_calc.c',
    'zend_shared_alloc.c',

# JIT doesn't currently work
#    'jit/zend_jit.c',
#    'jit/zend_jit_helpers.c',
#    'jit/zend_jit_ir.c',
#    'jit/zend_jit_trace.c',
#    'jit/zend_jit_vm_helpers.c',
)

if not cli_static_extensions.contains('opcache')
    shared_module(
        'opcache',
        [ext_opcache_sources],
        name_prefix: '',
        c_args : [],
        include_directories : [includes],
        install : true,
    )
endif

# header install (autoconf: PHP_INSTALL_HEADERS)
install_headers('zend_accelerator_api.h', subdir: 'php/ext/opcache')
