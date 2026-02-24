project(
    'punk',
    'c', 'cpp',
    meson_version : '>= 1.3.0',
    version : '0.1',
    default_options : ['warning_level=0', 'c_std=gnu23'],
)

cflags = [
    '-ffp-contract=off',
]

cc = meson.get_compiler('c')
add_project_arguments(cc.get_supported_arguments(cflags), language : 'c')
add_project_arguments('-DPUNK', language : ['c', 'cpp'])
add_project_arguments('-DPUNK_MESON', language : ['c', 'cpp'])
add_project_arguments('-DHAVE_MEMFD_CREATE', language : 'c')  # zend

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

# extensions that are static dependencies
#subdir('ext/date')
#subdir('ext/hash')
#subdir('ext/intl')
#subdir('ext/json')
#subdir('ext/lexbor')
#subdir('ext/libxml')
#subdir('ext/mysqli')
#subdir('ext/mysqlnd')
#subdir('ext/opcache')
#subdir('ext/pcre')
#subdir('ext/random')
#subdir('ext/readline')
#subdir('ext/reflection')
#subdir('ext/spl')
#subdir('ext/standard')
#subdir('ext/uri')

# shared library extensions
subdir('ext/bcmath')
subdir('ext/bz2')
subdir('ext/calendar')
# subdir('ext/com_dotnet')
subdir('ext/ctype')
subdir('ext/curl')
subdir('ext/date')
subdir('ext/dba')
subdir('ext/dl_test')
subdir('ext/dom')
subdir('ext/enchant')
subdir('ext/exif')
subdir('ext/ffi')
subdir('ext/fileinfo')
subdir('ext/filter')
subdir('ext/ftp')
subdir('ext/gd')
subdir('ext/gettext')
subdir('ext/gmp')
subdir('ext/hash')
subdir('ext/iconv')
subdir('ext/intl')
subdir('ext/json')
subdir('ext/ldap')
subdir('ext/lexbor')
subdir('ext/libxml')
subdir('ext/mbstring')
subdir('ext/mysqli')
subdir('ext/mysqlnd')
subdir('ext/odbc')
subdir('ext/opcache')
subdir('ext/openssl')
subdir('ext/pcntl')
subdir('ext/pcre')
subdir('ext/pdo')
# subdir('ext/pdo_dblib')
subdir('ext/pdo_firebird')
subdir('ext/pdo_mysql')
subdir('ext/pdo_odbc')
subdir('ext/pdo_pgsql')
subdir('ext/pdo_sqlite')
subdir('ext/pgsql')
subdir('ext/phar')
subdir('ext/posix')
subdir('ext/random')
subdir('ext/readline')
subdir('ext/reflection')
subdir('ext/session')
subdir('ext/shmop')
subdir('ext/simplexml')
subdir('ext/snmp')
subdir('ext/soap')
subdir('ext/sockets')
subdir('ext/sodium')
subdir('ext/spl')
subdir('ext/sqlite3')
subdir('ext/standard')
subdir('ext/sysvmsg')
subdir('ext/sysvsem')
subdir('ext/sysvshm')
subdir('ext/tidy')
subdir('ext/tokenizer')
subdir('ext/uri')
subdir('ext/xml')
subdir('ext/xmlreader')
subdir('ext/xmlwriter')
subdir('ext/xsl')
subdir('ext/zend_test')
subdir('ext/zip')
subdir('ext/zlib')

# SAPI modules
subdir('sapi/cli')

