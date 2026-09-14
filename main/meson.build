main_sources = files(
    'debug_gdb_scripts.c',
    'explicit_bzero.c',
    'fastcgi.c',
    'fopen_wrappers.c',
    'getopt.c',
    'internal_functions_cli.c',
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

main_objs = static_library(
    'main_objs',
    main_sources,
    c_args : [],
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

install_headers(
    'SAPI.h',
    build_defs_h,
    'fastcgi.h',
    'fopen_wrappers.h',
    'http_status_codes.h',
    'main_arginfo.h',
    'php.h',
    'php_compat.h',
    'php_config.h',
    'php_content_types.h',
    'php_getopt.h',
    'php_globals.h',
    'php_ini.h',
    'php_ini_builder.h',
    'php_main.h',
    'php_memory_streams.h',
    'php_network.h',
    'php_odbc_utils.h',
    'php_open_temporary_file.h',
    'php_output.h',
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
    subdir : 'main',
)

install_headers(
    'streams/php_stream_context.h',
    'streams/php_stream_filter_api.h',
    'streams/php_stream_glob_wrapper.h',
    'streams/php_stream_mmap.h',
    'streams/php_stream_plain_wrapper.h',
    'streams/php_stream_transport.h',
    'streams/php_stream_userspace.h',
    'streams/php_streams_int.h',
    'streams/userspace_arginfo.h',
    subdir : 'main/streams',
)
