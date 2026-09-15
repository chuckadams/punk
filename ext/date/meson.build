ext_date_sources = files(
    'php_date.c',
    'php_time.c',
    'time_duration.c',
    'lib/astro.c',
    'lib/dow.c',
    'lib/duration.c',
    'lib/interval.c',
    'lib/parse_date.c',
    'lib/parse_iso_intervals.c',
    'lib/parse_posix.c',
    'lib/parse_tz.c',
    'lib/timelib.c',
    'lib/tm2unixtime.c',
    'lib/unixtime2tm.c',
)

# timelib.h tests HAVE_TIMELIB_CONFIG_H before anything has included
# php_config.h, so it has to come from the command line -- config0.m4 passes it
# for the same reason.  Without it timelib_config.h is skipped, timelib falls
# back to malloc/free, and PHP frees that memory with efree.
ext_date_c_args = ['-DHAVE_TIMELIB_CONFIG_H=1']

# timelib_config.h lives in lib/ and is generated there (see lib/meson.build).
# lib/ is on the include path for every target, added in the root meson.build:
# php_date.h reaches it from other extensions too, so it is not ext/date's alone.
subdir('lib')

php_date_arginfo_gen = custom_target('php_date_arginfo', input: 'php_date.stub.php', output: 'php_date_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])
time_arginfo_gen = custom_target('time_arginfo', input: 'time.stub.php', output: 'time_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

ext_date_objs = static_library(
    'ext_date_objs',
    ext_date_sources,
    php_date_arginfo_gen[0],
    time_arginfo_gen[0],
    c_args : ext_date_c_args + static_c_args,
    include_directories : [includes, '.'],
    build_by_default : false,
)

if not cli_static_extensions.contains('date')
    shared_module(
        'date',
        [ext_date_sources],
        name_prefix: '',
        name_suffix: 'so',
        c_args : ext_date_c_args,
        include_directories : [includes],
        install : true,
    )
endif

install_headers(
    'php_date.h',
    subdir: 'php/ext/date',
)

install_headers(
    'lib/timelib.h',
    timelib_config_h,
    subdir: 'php/ext/date/lib',
)
