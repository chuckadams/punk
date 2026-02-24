ext_pdo_firebird_sources = files(
  'firebird_driver.c',
  'firebird_statement.c',
  'pdo_firebird.c',
  'pdo_firebird_utils.cpp',
)

shared_module(
    'pdo_firebird',
    [ext_pdo_firebird_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
)
