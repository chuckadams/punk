ext_pcntl_sources = files(
  'pcntl.c',
  'php_signal.c',
)

shared_module(
    'pcntl',
    [ext_pcntl_sources],
    name_prefix: '',
    c_args : ['-DHAVE_STRUCT_SIGINFO_T'], # TODO: detect siginfo_t on platform
    include_directories : [includes],
    dependencies: [],
)
