ext_filter_sources = files(
  'callback_filter.c',
  'filter.c',
  'logical_filters.c',
  'sanitizing_filters.c',
)

shared_module(
    'filter',
    [ext_filter_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    install : true,
)

install_headers(
    'php_filter.h',
    subdir: 'ext/filter',
)
