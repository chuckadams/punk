ext_date_sources = files(
    'php_date.c',
    'lib/astro.c',
    'lib/dow.c',
    'lib/interval.c',
    'lib/parse_date.c',
    'lib/parse_iso_intervals.c',
    'lib/parse_posix.c',
    'lib/parse_tz.c',
    'lib/timelib.c',
    'lib/tm2unixtime.c',
    'lib/unixtime2tm.c',
)

shared_module(
    'date',
    [ext_date_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    install : true,
)

install_headers(
    'php_date.h',
    subdir: 'ext/date',
)

install_headers(
    'lib/timelib.h',
    'lib/timelib_config.h',
    subdir: 'ext/date/lib',
)
