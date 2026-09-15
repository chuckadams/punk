calendar_arginfo_gen = custom_target(
    'calendar_arginfo',
    input: 'calendar.stub.php',
    output: [ 'calendar_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_calendar_sources = files(
  'cal_unix.c',
  'calendar.c',
  'dow.c',
  'easter.c',
  'french.c',
  'gregor.c',
  'jewish.c',
  'julian.c',
)

shared_module(
    'calendar',
    [ext_calendar_sources, calendar_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    install : true,
)
