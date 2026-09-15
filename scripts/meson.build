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
# php-config.in; embed, fpm and phpdbg are here so that --php-sapis answers what
# the install actually contains, the way autoconf's PHP_INSTALLED_SAPIS does.
sapis = ['cli', 'cgi', 'embed', 'fpm', 'phpdbg']

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

# ---------------------------------------------------------------------------
# phpize, and the build payload it copies into third-party extensions
# ---------------------------------------------------------------------------
#
# phpize is kept, and kept by shipping the autoconf machinery it needs rather
# than by replacing it: it copies these files into an extension and runs
# autoconf on the config.m4 it finds there.  The manifest is the one
# scripts/Makefile.frag's install-build used, and the destination has to be what
# phpize.in looks for -- it derives phpdir from @libdir@, so the payload lands
# in $prefix/lib/build.
#
# None of it is a build input of *this* tree any more; it is only ever executed
# by an extension author, which is why scripts/dev/check-phpize exists to prove
# it still works.

phpize_substitutions = configuration_data()
phpize_substitutions.set('prefix', prefix)
phpize_substitutions.set('exec_prefix', prefix)
phpize_substitutions.set('datarootdir', prefix / 'share')
phpize_substitutions.set('libdir', libdir)
phpize_substitutions.set('includedir', includedir)
phpize_substitutions.set('SED', find_program('sed').full_path())

phpize = configure_file(
    input : 'phpize.in',
    output : 'phpize',
    configuration : phpize_substitutions,
)

install_data(phpize, install_dir : get_option('bindir'), install_mode : 'rwxr-xr-x')

# The two man pages were AC_CONFIG_FILES upstream and need the same two values
# php-config does, so they are configured from that object rather than from a
# second copy of them that could drift.
install_man(configure_file(
    input : 'man1/phpize.1.in',
    output : 'phpize.1',
    configuration : php_config_substitutions,
))

install_man(configure_file(
    input : 'man1/php-config.1.in',
    output : 'php-config.1',
    configuration : php_config_substitutions,
))

phpize_payload_dir = libdir / 'build'

# php.m4 and the libtool/ax/pkg macro files are what the extension's config.m4
# is expanded against.  ltmain.sh is what generates its libtool, Makefile.global
# is the skeleton PHP_GEN_GLOBAL_MAKEFILE assembles its Makefile from, shtool is
# used both at configure time ($php_shtool) and from the generated Makefile, and
# run-tests.php is what makes `make test` work in the extension.
phpize_payload = files(
    'phpize.m4',
    '../run-tests.php',
    '../build/php.m4',
    '../build/libtool.m4',
    '../build/ltmain.sh',
    '../build/ltoptions.m4',
    '../build/ltsugar.m4',
    '../build/ltversion.m4',
    '../build/lt~obsolete.m4',
    '../build/ax_check_compile_flag.m4',
    '../build/ax_gcc_func_attribute.m4',
    '../build/php_cxx_compile_stdcxx.m4',
    '../build/pkg.m4',
    '../build/Makefile.global',
    '../build/gen_stub.php',
)

install_data(phpize_payload, install_dir : phpize_payload_dir)

# These three are executed -- by the extension's configure (config.guess and
# config.sub through libtool) and by both configure and make (shtool) -- so they
# need the executable bit that install_data does not set by default.  phpize
# chmods shtool itself, but the same call gets all three right the first time.
install_data(files(
    '../build/shtool',
    '../build/config.guess',
    '../build/config.sub',
), install_dir : phpize_payload_dir, install_mode : 'rwxr-xr-x')

# gen_stub.php needs PhpParser, and downloads it from GitHub when it is not
# beside itself -- so an out-of-tree extension with a .stub.php would need the
# network at build time.  Vendoring the pinned version next to the copy of
# gen_stub.php above is what makes that rule work offline.  The version is
# pinned in gen_stub.php itself, so bumping PHP-Parser means bumping both.
install_subdir('../build/PHP-Parser-5.6.1', install_dir : phpize_payload_dir)
