ext_sockets_sources = files(
  'conversions.c',
  'multicast.c',
  'sendrecvmsg.c',
  'sockaddr_conv.c',
  'sockets.c',
)

shared_module(
    'sockets',
    [ext_sockets_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
)
