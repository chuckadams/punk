ext_com_dotnet_sources = files(
  'com_com.c',
  'com_dotnet.c',
  'com_extension.c',
  'com_handlers.c',
  'com_iterator.c',
  'com_misc.c',
  'com_olechar.c',
  'com_persist.c',
  'com_saproxy.c',
  'com_typeinfo.c',
  'com_variant.c',
  'com_wrapper.c',
  'tests/comtest/comtest.cpp',
)

shared_module(
    'com_dotnet',
    [ext_com_dotnet_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    install : true,
)
