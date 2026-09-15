pcntl_arginfo_gen = custom_target(
    'pcntl_arginfo',
    input: 'pcntl.stub.php',
    output: [ 'pcntl_arginfo.h', 'pcntl_decl.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_pcntl_sources = files(
  'pcntl.c',
  'php_signal.c',
)

shared_module(
    'pcntl',
    [ext_pcntl_sources, pcntl_arginfo_gen[0], pcntl_arginfo_gen[1]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : ['-DHAVE_STRUCT_SIGINFO_T'], # TODO: detect siginfo_t on platform
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
