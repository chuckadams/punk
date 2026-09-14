main_sources = files(
    'debug_gdb_scripts.c',
    'explicit_bzero.c',
    'fastcgi.c',
    'fopen_wrappers.c',
    'getopt.c',
    'main.c',
    'network.c',
    'output.c',
    'php_content_types.c',
    'php_glob.c',
    'php_ini_builder.c',
    'php_ini.c',
    'php_odbc_utils.c',
    'php_open_temporary_file.c',
    'php_scandir.c',
    'php_syslog.c',
    'php_ticks.c',
    'php_variables.c',
    'reentrancy.c',
    'rfc1867.c',
    'safe_bcmp.c',
    'SAPI.c',
    'snprintf.c',
    'spprintf.c',
    'strlcat.c',
    'strlcpy.c',
    'io/php_io.c',
    'io/php_io_copy_freebsd.c',
    'io/php_io_copy_linux.c',
    'io/php_io_copy_macos.c',
    'io/php_io_copy_solaris.c',
    'io/php_io_copy_windows.c',
    'poll/poll_backend_epoll.c',
    'poll/poll_backend_eventport.c',
    'poll/poll_backend_kqueue.c',
    'poll/poll_backend_poll.c',
    'poll/poll_backend_wsapoll.c',
    'poll/poll_core.c',
    'poll/poll_fd_table.c',
    'poll/poll_handle.c',
    'streams/cast.c',
    'streams/filter.c',
    'streams/glob_wrapper.c',
    'streams/memory.c',
    'streams/mmap.c',
    'streams/plain_wrapper.c',
    'streams/streams.c',
    'streams/stream_errors.c',
    'streams/transports.c',
    'streams/userspace.c',
    'streams/xp_socket.c',
)

# internal_functions_cli.c lists the extensions linked into the front-ends.  Both
# orders matter: the include order follows the extension list and the module
# pointer order is the registration order, which build/order_by_dep.awk sorted by
# the extensions' dependencies (mysqlnd before mysqli, and so on).  They are
# recorded here rather than derived, so adding a statically linked extension means
# adding it to cli_static_extensions in the root meson.build and to both lists
# below.
internal_functions_includes = [
    '#include "ext/date/php_date.h"',
    '#include "ext/libxml/php_libxml.h"',
    '#include "ext/pcre/php_pcre.h"',
    '#include "ext/hash/php_hash.h"',
    '#include "ext/intl/php_intl.h"',
    '#include "ext/json/php_json.h"',
    '#include "ext/lexbor/php_lexbor.h"',
    '#include "ext/mysqli/php_mysqli.h"',
    '#include "ext/opcache/zend_accelerator_module.h"',
    '#include "ext/random/php_random.h"',
    '#include "ext/readline/php_readline.h"',
    '#include "ext/reflection/php_reflection.h"',
    '#include "ext/spl/php_spl.h"',
    '#include "ext/standard/php_standard.h"',
    '#include "ext/uri/php_uri.h"',
    '#include "ext/mysqlnd/php_mysqlnd.h"',
]

internal_functions_ptrs = [
    '\tphpext_date_ptr,',
    '\tphpext_libxml_ptr,',
    '\tphpext_pcre_ptr,',
    '\tphpext_hash_ptr,',
    '\tphpext_intl_ptr,',
    '\tphpext_json_ptr,',
    '\tphpext_lexbor_ptr,',
    '\tphpext_mysqlnd_ptr,',
    '\tphpext_standard_ptr,',
    '\tphpext_spl_ptr,',
    '\tphpext_mysqli_ptr,',
    '\tphpext_opcache_ptr,',
    '\tphpext_random_ptr,',
    '\tphpext_readline_ptr,',
    '\tphpext_reflection_ptr,',
    '\tphpext_uri_ptr,',
]

internal_functions_defs = configuration_data()
internal_functions_defs.set('EXT_INCLUDE_CODE', '\n'.join(internal_functions_includes) + '\n')
internal_functions_defs.set('EXT_MODULE_PTRS', '\n'.join(internal_functions_ptrs) + '\n')
internal_functions_defs.set('NEWLINE', '\n')

# The CLI and CGI front-ends link the same extensions, so one generated file
# serves both; autoconf's other variant (main/internal_functions.c) existed for
# SAPIs with a different built-in set.
internal_functions_cli_c = configure_file(
    input : 'internal_functions.c.in',
    output : 'internal_functions_cli.c',
    configuration : internal_functions_defs,
)

main_sources += internal_functions_cli_c

main_objs = static_library(
    'main_objs',
    main_sources,
    c_args : static_c_args,
    include_directories : [includes],
    build_by_default : false,
)

# build-defs.h holds the compiled-in install paths, including PHP_EXTENSION_DIR,
# which is the default of the extension_dir ini setting. Autotools derives it
# from its own (oldstyle) layout under $libdir/php; meson installs shared modules
# straight into $libdir, so generate it here to keep the two in step.
php_prefix = get_option('prefix')

dir_options = {
    'bindir': get_option('bindir'),
    'sbindir': get_option('sbindir'),
    'mandir': get_option('mandir'),
    'libdir': get_option('libdir'),
    'datadir': get_option('datadir'),
    'sysconfdir': get_option('sysconfdir'),
    'localstatedir': get_option('localstatedir'),
}
php_dirs = {}
foreach name, value : dir_options
    if value.startswith('/')
        php_dirs += {name: value}
    else
        php_dirs += {name: php_prefix / value}
    endif
endforeach

build_defs = configuration_data()
build_defs.set('CONFIGURE_COMMAND', 'meson')
build_defs.set('PROG_SENDMAIL', '/usr/sbin/sendmail')
build_defs.set('EXPANDED_PEAR_INSTALLDIR', '')
build_defs.set('INCLUDE_PATH', '.:')
build_defs.set('EXPANDED_EXTENSION_DIR', php_dirs['libdir'])
build_defs.set('prefix', php_prefix)
build_defs.set('EXPANDED_BINDIR', php_dirs['bindir'])
build_defs.set('EXPANDED_SBINDIR', php_dirs['sbindir'])
build_defs.set('EXPANDED_MANDIR', php_dirs['mandir'])
build_defs.set('EXPANDED_LIBDIR', php_dirs['libdir'])
build_defs.set('EXPANDED_DATADIR', php_dirs['datadir'])
build_defs.set('EXPANDED_SYSCONFDIR', php_dirs['sysconfdir'])
build_defs.set('EXPANDED_LOCALSTATEDIR', php_dirs['localstatedir'])
build_defs.set('EXPANDED_PHP_CONFIG_FILE_PATH', php_dirs['libdir'])
build_defs.set('EXPANDED_PHP_CONFIG_FILE_SCAN_DIR', '')
build_defs.set('SHLIB_DL_SUFFIX_NAME', 'so')

build_defs_h = configure_file(
    input: 'build-defs.h.in',
    output: 'build-defs.h',
    configuration: build_defs,
)

# The configuration header lives here rather than in build/ so that it is
# generated into the build's main/ directory: Zend/zend_config.h (generated into
# the build's Zend/) includes <../main/php_config.h>, which only resolves if the
# two are siblings in the build tree.  build/meson.build filled the data in.
php_config_h = configure_file(
    input: php_config_template,
    output: 'php_config.h',
    configuration: php_config_defs,
)

install_headers(
    'SAPI.h',
    build_defs_h,
    'charclass.h',
    'fastcgi.h',
    'fopen_wrappers.h',
    'http_status_codes.h',
    'main_arginfo.h',
    'php.h',
    'php_compat.h',
    php_config_h,
    'php_content_types.h',
    'php_getopt.h',
    'php_glob.h',
    'php_globals.h',
    'php_ini.h',
    'php_ini_builder.h',
    'php_io.h',
    'php_main.h',
    'php_memory_streams.h',
    'php_network.h',
    'php_odbc_utils.h',
    'php_open_temporary_file.h',
    'php_output.h',
    'php_poll.h',
    'php_reentrancy.h',
    'php_scandir.h',
    'php_streams.h',
    'php_syslog.h',
    'php_ticks.h',
    'php_variables.h',
    'php_version.h',
    'rfc1867.h',
    'snprintf.h',
    'spprintf.h',
    subdir : 'php/main',
)

install_headers(
    'streams/php_stream_context.h',
    'streams/php_stream_errors.h',
    'streams/php_stream_filter_api.h',
    'streams/php_stream_glob_wrapper.h',
    'streams/php_stream_mmap.h',
    'streams/php_stream_plain_wrapper.h',
    'streams/php_stream_transport.h',
    'streams/php_stream_userspace.h',
    'streams/php_streams_int.h',
    'streams/stream_errors_arginfo.h',
    'streams/stream_errors_decl.h',
    'streams/userspace_arginfo.h',
    subdir : 'php/main/streams',
)
