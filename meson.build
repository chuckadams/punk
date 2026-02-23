project(
    'punk',
    'c', 'cpp',
    meson_version : '>= 1.3.0',
    version : '0.1',
    default_options : ['warning_level=0', 'c_std=gnu23'],
)

cflags = [
]

cc = meson.get_compiler('c')
add_project_arguments(cc.get_supported_arguments(cflags), language: 'c')
add_project_arguments('-DPUNK', language: ['c', 'cpp'])
add_project_arguments('-DPUNK_MESON', language: ['c', 'cpp'])
add_project_arguments('-DHAVE_MEMFD_CREATE', language: 'c')  # zend

dependencies = [
    dependency('icu-i18n'),
    dependency('icu-io'),
    dependency('libargon2'),
    dependency('libavif'),
    dependency('libedit'),
    dependency('libxml-2.0'),
    dependency('openssl'),
    dependency('threads'),
    dependency('zlib'),
    cc.find_library('m'),
]

includes = include_directories(
    '.',
    'main',
    'Zend',
    'TSRM',
    'ext/intl',
    'ext/lexbor',
    'ext/opcache',
    'ext/uri/uriparser/include',
)

subdir('main')
subdir('TSRM')
subdir('Zend')

subdir('ext/date')
subdir('ext/hash')
subdir('ext/intl')
subdir('ext/json')
subdir('ext/lexbor')
subdir('ext/libxml')
subdir('ext/mysqli')
subdir('ext/mysqlnd')
subdir('ext/opcache')
subdir('ext/pcre')
subdir('ext/random')
subdir('ext/readline')
subdir('ext/reflection')
subdir('ext/spl')
subdir('ext/standard')
subdir('ext/uri')

subdir('sapi/cli')
