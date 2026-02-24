ext_enchant_sources = files(
  'enchant.c',
)

shared_module(
    'enchant',
    [ext_enchant_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('enchant-2')],
    install : true,
)
