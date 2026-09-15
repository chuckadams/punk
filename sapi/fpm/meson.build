# FPM (FastCGI Process Manager).  Unlike the other front-ends this one is a real
# service: php-fpm forks a master process and a pool of workers, so it needs its
# own event loops, scoreboard, socket handling and logging.  It is nevertheless
# built the same way as the CLI and CGI -- one executable that carries the whole
# engine -- and it keeps upstream's name, php-fpm, because the name is baked into
# the init script, the man page, the tests' configuration and the systemd unit.

sapi_fpm_sources = files(
    'fpm/fpm.c',
    'fpm/fpm_children.c',
    'fpm/fpm_cleanup.c',
    'fpm/fpm_clock.c',
    'fpm/fpm_conf.c',
    'fpm/fpm_env.c',
    'fpm/fpm_events.c',
    'fpm/fpm_log.c',
    'fpm/fpm_main.c',
    'fpm/fpm_php.c',
    'fpm/fpm_php_trace.c',
    'fpm/fpm_process_ctl.c',
    'fpm/fpm_request.c',
    'fpm/fpm_shm.c',
    'fpm/fpm_scoreboard.c',
    'fpm/fpm_signals.c',
    'fpm/fpm_sockets.c',
    'fpm/fpm_status.c',
    'fpm/fpm_stdio.c',
    'fpm/fpm_unix.c',
    'fpm/fpm_worker_pool.c',
    'fpm/zlog.c',
    # One file per event loop, selected at run time; only the ones the platform
    # has compile to anything, which is how config.m4 builds them too.
    'fpm/events/select.c',
    'fpm/events/poll.c',
    'fpm/events/epoll.c',
    'fpm/events/kqueue.c',
    'fpm/events/port.c',
)

# The slowlog trace needs exactly one memory-reading backend: fpm_config.h turns
# whichever of HAVE_PTRACE / PROC_MEM_FILE / HAVE_MACH_VM_READ the probes in
# build/meson.build found into HAVE_FPM_TRACE, and fpm_php_trace.c compiles only
# when it is set.  config.m4 picks the backend in this order and only adds
# fpm_trace.c alongside it.
if php_config_defs.has('HAVE_PTRACE')
    sapi_fpm_sources += files('fpm/fpm_trace.c', 'fpm/fpm_trace_ptrace.c')
elif php_config_defs.has('PROC_MEM_FILE')
    sapi_fpm_sources += files('fpm/fpm_trace.c', 'fpm/fpm_trace_pread.c')
elif php_config_defs.has('HAVE_MACH_VM_READ')
    sapi_fpm_sources += files('fpm/fpm_trace.c', 'fpm/fpm_trace_mach.c')
endif

fpm_main_arginfo_gen = custom_target('fpm_main_arginfo', input: 'fpm/fpm_main.stub.php', output: 'fpm_main_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

php_fpm_exe = executable(
    'php-fpm',
    # ext/standard/basic_functions.c includes <zend_language_parser.h> and
    # ext/opcache includes zend_vm_opcodes.h, both generated in Zend/; listing
    # them as sources orders the generators before this target compiles.
    [punk_frontend_sources, sapi_fpm_sources, zend_language_parser_gen[1], zend_vm_gen[0],
     fpm_main_arginfo_gen[0], punk_frontend_arginfo],
    c_args : static_c_args,
    dependencies : punk_frontend_dependencies,
    # '.' is sapi/fpm, which fpm_php.h needs for its "fpm/fpm_conf.h" include and
    # the generated arginfo header needs to be found next to its consumer.
    include_directories : [includes, '.'],
    link_whole : punk_frontend_link_whole,
    export_dynamic : true,
    install : true,
    # php-fpm is an administrative daemon, so it goes in sbin, not bin --
    # scripts that expect it there include the init script and the systemd unit.
    install_dir : get_option('sbindir'),
)

# A smoke test of the built binary, which is what `just unit-test` runs: starting
# up far enough to print the version exercises SAPI registration, module startup
# and a full request startup/shutdown without needing a pool to connect to.
test('sapi_fpm_test_version', php_fpm_exe, args : ['-n', '--version'])

# The configuration files and the man page are templates the autoconf build
# filled in from the install layout.  That layout comes from meson's directory
# options here, so the two agree by construction -- including EXPANDED_*, which
# the comments in php-fpm.conf and www.conf quote back at the reader.
fpm_prefix = get_option('prefix')
fpm_dir_options = {
    'sbindir': get_option('sbindir'),
    'sysconfdir': get_option('sysconfdir'),
    'localstatedir': get_option('localstatedir'),
    'datadir': get_option('datadir'),
}
fpm_dirs = {}
foreach name, value : fpm_dir_options
    if value.startswith('/')
        fpm_dirs += {name: value}
    else
        fpm_dirs += {name: fpm_prefix / value}
    endif
endforeach

fpm_conf_data = configuration_data()
fpm_conf_data.set('prefix', fpm_prefix)
fpm_conf_data.set('exec_prefix', fpm_prefix)
fpm_conf_data.set('sbindir', fpm_dirs['sbindir'])
fpm_conf_data.set('sysconfdir', fpm_dirs['sysconfdir'])
fpm_conf_data.set('localstatedir', fpm_dirs['localstatedir'])
fpm_conf_data.set('EXPANDED_SBINDIR', fpm_dirs['sbindir'])
fpm_conf_data.set('EXPANDED_SYSCONFDIR', fpm_dirs['sysconfdir'])
fpm_conf_data.set('EXPANDED_LOCALSTATEDIR', fpm_dirs['localstatedir'])
fpm_conf_data.set('EXPANDED_DATADIR', fpm_dirs['datadir'])
# The same paths under the names config.m4's AC_SUBST used, because the man page
# and www.conf mention them.
fpm_conf_data.set('php_fpm_prefix', fpm_prefix)
fpm_conf_data.set('php_fpm_sysconfdir', fpm_dirs['sysconfdir'])
fpm_conf_data.set('php_fpm_localstatedir', fpm_dirs['localstatedir'])
# --with-fpm-user/--with-fpm-group.  config.m4 defaults both to nobody, and there
# are no meson options for them yet.
fpm_conf_data.set('php_fpm_user', 'nobody')
fpm_conf_data.set('php_fpm_group', 'nobody')
# Type= in the systemd unit: "notify" needs --with-fpm-systemd, which is off, so
# the unit is a plain one.
fpm_conf_data.set('php_fpm_systemd', 'simple')
fpm_conf_data.set('PHP_VERSION', php_version)

fpm_php_fpm_conf = configure_file(input : 'php-fpm.conf.in', output : 'php-fpm.conf', configuration : fpm_conf_data)
fpm_www_conf = configure_file(input : 'www.conf.in', output : 'www.conf', configuration : fpm_conf_data)
fpm_php_fpm_8 = configure_file(input : 'php-fpm.8.in', output : 'php-fpm.8', configuration : fpm_conf_data)
# No substitutions in the status page, so it is copied rather than configured.
fpm_status_html = configure_file(input : 'status.html.in', output : 'status.html', copy : true)

# Generated for packagers but not installed, matching upstream's install-fpm
# target: the init script and the unit file are things a package ships in its own
# place, not in the PHP install.
configure_file(input : 'init.d.php-fpm.in', output : 'init.d.php-fpm', configuration : fpm_conf_data)
configure_file(input : 'php-fpm.service.in', output : 'php-fpm.service', configuration : fpm_conf_data)

# What autoconf's install-fpm target installs, to the same places.  Both config
# files are installed as .default so that an existing php-fpm.conf is never
# overwritten.
install_data(fpm_php_fpm_conf, install_dir : fpm_dirs['sysconfdir'], rename : 'php-fpm.conf.default')
install_data(fpm_www_conf, install_dir : fpm_dirs['sysconfdir'] / 'php-fpm.d', rename : 'www.conf.default')
install_data(fpm_status_html, install_dir : fpm_dirs['datadir'] / 'fpm')
install_man(fpm_php_fpm_8)
