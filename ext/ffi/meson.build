ffi_arginfo_gen = custom_target(
    'ffi_arginfo',
    input: 'ffi.stub.php',
    output: [ 'ffi_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_ffi_sources = files(
  'ffi.c',
  'ffi_parser.c',
)

shared_module(
    'ffi',
    [ext_ffi_sources, ffi_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies : [dependency('libffi')],
    install : true,
)
