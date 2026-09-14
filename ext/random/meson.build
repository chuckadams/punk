ext_random_sources = files(
    'csprng.c',
    'engine_mt19937.c',
    'engine_pcgoneseq128xslrr64.c',
    'engine_secure.c',
    'engine_user.c',
    'engine_xoshiro256starstar.c',
    'gammasection.c',
    'random.c',
    'randomizer.c',
    'zend_utils.c',
)

random_arginfo_gen = custom_target('random_arginfo', input: 'random.stub.php', output: ['random_arginfo.h', 'random_decl.h'], command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/ext/random')

if not cli_static_extensions.contains('random')
    shared_module(
        'random',
        [ext_random_sources],
        name_prefix: '',
        c_args: [],
        include_directories : [includes],
        install : true,
    )
endif

install_headers(
    'php_random.h',
    'php_random_csprng.h',
    'php_random_uint128.h',
    subdir: 'php/ext/random',
)
