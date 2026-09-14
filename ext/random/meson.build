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
    subdir: 'ext/random',
)
