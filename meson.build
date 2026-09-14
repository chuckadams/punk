project(
    'punk',
    'c', 'cpp',
    meson_version : '>= 1.3.0',
    version : '0.1',
    default_options : ['warning_level=0', 'c_std=gnu23'],
)

cflags = [
    '-ffp-contract=off',    # https://github.com/php/php-src/issues/14140
]

fs = import('fs')

cc = meson.get_compiler('c')
add_project_arguments(cc.get_supported_arguments(cflags), language : 'c')
add_project_arguments(['-DPUNK', '-DPUNK_MESON'], language : ['c', 'cpp'])

# Extensions compiled straight into the punk binary; see sapi/cli/meson.build,
# which lists their sources. Building them as loadable modules as well would
# produce .so files without a module entry point, because a static build never
# defines COMPILE_DL_<name> (autoconf puts that in php_config.h per extension).
cli_static_extensions = [
    'date',
    'hash',
    'intl',
    'json',
    'lexbor',
    'libxml',
    'mysqli',
    'mysqlnd',
    'opcache',
    'pcre',
    'random',
    'readline',
    'reflection',
    'spl',
    'standard',
    'uri',
]

# Configuration checks for the generated config header.  Meson has no separate
# configure phase: this runs at setup (and again whenever the build description
# changes or options are edited), which is the equivalent of autoconf's
# configure step.  There is deliberately no option gating it.
#
# The data is created here so that two subdirectories can share it: build/ fills
# it in with the platform checks, main/ writes the header out of it.  It has to
# be written from main/ because configure_file() cannot write into a
# subdirectory of the build directory, and Zend/zend_config.h -- which meson
# generates into the build's Zend/ -- includes <../main/php_config.h>.
php_config_defs = configuration_data()
php_config_template = files('build/php_config.h.in')

subdir('build')

includes = include_directories(
    '.',
    'main',
    'Zend',
    'TSRM',
    'ext/lexbor',
    'ext/uri/uriparser/include',
    # timelib.h includes timelib_config.h from its own directory, and that file
    # is generated into the build's ext/date/lib/ (see ext/date/lib/meson.build)
    # rather than written into the source tree.  ext/date itself is only the
    # first consumer: ext/intl, ext/opcache, ext/session, ext/soap and
    # ext/standard all reach it through php_date.h.
    'ext/date/lib',
    # The re2c/bison-generated .c files live in the build tree, so a quoted
    # include no longer finds the sibling headers in their own source directory
    # the way a checked-out source file would.  These are the four extensions
    # whose generated files include a non-generated sibling by bare name.
    'ext/standard',
    'ext/json',
    'ext/pdo',
    'ext/phar',
)


# Autotools compiles everything that ends up inside a binary with
# -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 (build/php.m4), which decides how the TSRM
# context is reached.  Building only part of a binary that way leaves the two
# access paths mixed, so apply it to every static part of the front-ends.
static_c_args = ['-DZEND_ENABLE_STATIC_TSRMLS_CACHE=1']

subdir('main')
subdir('TSRM')
subdir('Zend')

# Interoperability check.  autoconf also writes main/php_config.h, into the
# source tree, and for the sources in main/ that copy wins over the generated
# one -- a quoted include looks in the including file's own directory first.
# Whenever both exist they should say the same thing, so a disagreement (an
# autotools configuration with different options, say) is worth a warning
# rather than a binary quietly built from two configurations.
compare_config_headers = find_program('scripts/dev/compare-config-headers', required: false)
autoconf_php_config_h = meson.current_source_dir() / 'main/php_config.h'
if compare_config_headers.found() and fs.is_file(autoconf_php_config_h)
    compare = run_command(
        compare_config_headers,
        autoconf_php_config_h,
        meson.current_build_dir() / 'main/php_config.h',
        check: false,
    )
    if compare.returncode() != 0
        warning('the source tree\'s main/php_config.h (autoconf) and the generated one differ; run `just compare-config` for the details')
    endif
endif

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
# odbc: not enabled by the autotools configuration either, and without
# COMPILE_DL_ODBC the module has no entry point.  See the justfile to-do list.
# subdir('ext/odbc')
subdir('ext/opcache')
subdir('ext/openssl')
subdir('ext/pcntl')
subdir('ext/pcre')
subdir('ext/pdo')
# subdir('ext/pdo_dblib')
subdir('ext/pdo_firebird')
subdir('ext/pdo_mysql')
# subdir('ext/pdo_odbc')
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

# SAPI modules.
#
# Both front-ends are built from the same core: the sources and libraries below
# are compiled straight into each binary, while everything else in ext/ is a
# shared module loaded at runtime.  Keep this in sync with
# cli_static_extensions above, which stops those extensions from also being
# built as (entry-point-less) modules.
punk_frontend_sources = [
    main_sources,
    tsrm_sources,
    ext_json_sources,
    ext_lexbor_sources,
    ext_libxml_sources,
    ext_mysqli_sources,
    ext_mysqlnd_sources,
    ext_opcache_sources,
    ext_readline_sources,
    ext_random_sources,
    ext_reflection_sources,
    ext_spl_sources,
    ext_standard_sources,
    ext_uri_sources,
]

punk_frontend_dependencies = [
    dependency('icu-i18n'),
    dependency('icu-io'),
    dependency('libargon2'),
    dependency('libavif'), # needed because of ext/standard/image.c
    dependency('libedit'),
    dependency('libxml-2.0'),
    dependency('openssl'),
    dependency('threads'),
    dependency('zlib'),
    cc.find_library('m'),
]

punk_frontend_link_whole = [
    zend_objs,
    ext_date_objs,
    ext_hash_objs,
    ext_intl_objs,
    ext_pcre_objs,
]

subdir('scripts')
subdir('sapi/cli')
subdir('sapi/cgi')
