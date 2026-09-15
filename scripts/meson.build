# php-config: the installed developer interface.  Its values come from the meson
# options and from the two generated headers; the library list is the set of
# libraries the front-ends link, which is what an out-of-tree module needs to
# link against this install.  Note that punk builds no shared PHP library, so
# --ldflags is empty.
#
# php_version/php_version_id come from the root meson.build, which reads them out
# of main/php_version.h.

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

# The front-ends this build installs.  Only cli and cgi are special-cased in
# php-config.in; embed and fpm are here so that --php-sapis answers what the
# install actually contains, the way autoconf's PHP_INSTALLED_SAPIS does.
sapis = ['cli', 'cgi', 'embed', 'fpm']

# The @name@ substitutions for php-config.in.  Deliberately not called
# php_config_defs: that name holds the generated C header's configuration_data
# (created in the root meson.build), and rebinding it here would leave every
# subdir after this one -- sapi/fpm, which picks its trace backend out of it --
# reading this object instead.
php_config_substitutions = configuration_data()
php_config_substitutions.set('SED', find_program('sed').full_path())
php_config_substitutions.set('prefix', prefix)
php_config_substitutions.set('exec_prefix', prefix)
php_config_substitutions.set('bindir', prefix / 'bin')
php_config_substitutions.set('includedir', includedir)
php_config_substitutions.set('mandir', prefix / 'share' / 'man')
php_config_substitutions.set('datarootdir', prefix / 'share')
php_config_substitutions.set('orig_libdir', libdir)
php_config_substitutions.set('EXTENSION_DIR', libdir)
php_config_substitutions.set('EXPANDED_PHP_CONFIG_FILE_PATH', libdir)
php_config_substitutions.set('EXPANDED_PHP_CONFIG_FILE_SCAN_DIR', '')
php_config_substitutions.set('PHP_VERSION', php_version)
php_config_substitutions.set('PHP_VERSION_ID', php_version_id)
php_config_substitutions.set('program_prefix', '')
php_config_substitutions.set('program_suffix', '')
php_config_substitutions.set('EXEEXT', '')
# Unlike upstream -- and unlike the autoconf build, which keeps upstream's name --
# the meson build installs the CLI as "punk", so php-config has to report that.
php_config_substitutions.set('PHP_CLI_BINARY_NAME', 'punk')
php_config_substitutions.set('PHP_EMBED_TYPE', '')
php_config_substitutions.set('SAPI_LIBNAME_SHARED', '')
php_config_substitutions.set('SAPI_LIBNAME_STATIC', '')
php_config_substitutions.set('PHP_LDFLAGS', '')
php_config_substitutions.set('EXTRA_LIBS', ' ' + ' '.join([
    '-lstdc++', '-lm', '-lpthread', '-lxml2', '-lpcre2-8', '-licui18n',
    '-licuuc', '-licudata', '-ledit', '-largon2', '-lz', '-lssl', '-lcrypto', '-ldl',
]))
php_config_substitutions.set('CONFIGURE_OPTIONS', ' '.join(configure_options))
php_config_substitutions.set('PHP_INSTALLED_SAPIS', ' ' + ' '.join(sapis))

php_config = configure_file(
    input : 'php-config.in',
    output : 'php-config',
    configuration : php_config_substitutions,
)

install_data(php_config, install_dir : get_option('bindir'), install_mode : 'rwxr-xr-x')
