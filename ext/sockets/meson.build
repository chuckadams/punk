ext_sockets_sources = files(
  'conversions.c',
  'multicast.c',
  'sendrecvmsg.c',
  'sockaddr_conv.c',
  'sockets.c',
)

sockets_arginfo_gen = custom_target(
    'sockets_arginfo',
    input: 'sockets.stub.php',
    output: [ 'sockets_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'sockets',
    [ext_sockets_sources, sockets_arginfo_gen[0]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)

install_headers(
    'php_sockets.h',
    subdir: 'php/ext/sockets',
)
