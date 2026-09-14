# php-config: the installed developer interface.  Its values come from the meson
# options and from the two generated headers; the library list is the set of
# libraries the front-ends link, which is what an out-of-tree module needs to
# link against this install.  Note that punk builds no shared PHP library, so
# --ldflags is empty.
fs = import('fs')

php_version = ''
php_version_id = 0
foreach line : fs.read(meson.project_source_root() / 'main/php_version.h').split('\n')
    stripped = line.strip()
    if stripped.startswith('#define PHP_VERSION ')
        php_version = stripped.replace('#define PHP_VERSION ', '').strip().replace('"', '')
    elif stripped.startswith('#define PHP_VERSION_ID ')
        php_version_id = stripped.replace('#define PHP_VERSION_ID ', '').strip().to_int()
    endif
endforeach
if php_version == '' or php_version_id == 0
    error('could not read PHP_VERSION/PHP_VERSION_ID from main/php_version.h')
endif

prefix = get_option('prefix')
libdir = get_option('libdir')
includedir = get_option('includedir')
if not libdir.startswith('/')
    libdir = prefix / libdir
endif
if not includedir.startswith('/')
    includedir = prefix / includedir
endif

# The equivalent of the old configure line, as a meson setup invocation.
configure_options = [
    '-Dzts=' + get_option('zts').to_string(),
    '-Dzend-debug=' + get_option('zend-debug').to_string(),
    '-Dsigchild=' + get_option('sigchild').to_string(),
    '-Dfiber-asm=' + get_option('fiber-asm').to_string(),
]

sapis = ['cli', 'cgi']

php_config_defs = configuration_data()
php_config_defs.set('SED', find_program('sed').full_path())
php_config_defs.set('prefix', prefix)
php_config_defs.set('exec_prefix', prefix)
php_config_defs.set('bindir', prefix / 'bin')
php_config_defs.set('includedir', includedir)
php_config_defs.set('mandir', prefix / 'share' / 'man')
php_config_defs.set('datarootdir', prefix / 'share')
php_config_defs.set('orig_libdir', libdir)
php_config_defs.set('EXTENSION_DIR', libdir)
php_config_defs.set('EXPANDED_PHP_CONFIG_FILE_PATH', libdir)
php_config_defs.set('EXPANDED_PHP_CONFIG_FILE_SCAN_DIR', '')
php_config_defs.set('PHP_VERSION', php_version)
php_config_defs.set('PHP_VERSION_ID', php_version_id)
php_config_defs.set('program_prefix', '')
php_config_defs.set('program_suffix', '')
php_config_defs.set('EXEEXT', '')
# Unlike upstream -- and unlike the autoconf build, which keeps upstream's name --
# the meson build installs the CLI as "punk", so php-config has to report that.
php_config_defs.set('PHP_CLI_BINARY_NAME', 'punk')
php_config_defs.set('PHP_EMBED_TYPE', '')
php_config_defs.set('SAPI_LIBNAME_SHARED', '')
php_config_defs.set('SAPI_LIBNAME_STATIC', '')
php_config_defs.set('PHP_LDFLAGS', '')
php_config_defs.set('EXTRA_LIBS', ' ' + ' '.join([
    '-lstdc++', '-lm', '-lpthread', '-lxml2', '-lpcre2-8', '-licui18n',
    '-licuuc', '-licudata', '-ledit', '-largon2', '-lz', '-lssl', '-lcrypto', '-ldl',
]))
php_config_defs.set('CONFIGURE_OPTIONS', ' '.join(configure_options))
php_config_defs.set('PHP_INSTALLED_SAPIS', ' ' + ' '.join(sapis))

php_config = configure_file(
    input : 'php-config.in',
    output : 'php-config',
    configuration : php_config_defs,
)

install_data(php_config, install_dir : get_option('bindir'), install_mode : 'rwxr-xr-x')
