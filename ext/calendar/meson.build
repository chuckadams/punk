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
    [ext_calendar_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
)
