filter_arginfo_gen = custom_target(
    'filter_arginfo',
    input: 'filter.stub.php',
    output: [ 'filter_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_filter_sources = files(
  'callback_filter.c',
  'filter.c',
  'logical_filters.c',
  'sanitizing_filters.c',
)

shared_module(
    'filter',
    [ext_filter_sources, filter_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    install : true,
)

install_headers(
    'php_filter.h',
    subdir: 'php/ext/filter',
)
