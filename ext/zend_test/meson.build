ext_zend_test_sources = files(
  'fiber.c',
  'iterators.c',
  'object_handlers.c',
  'observer.c',
  'test.c',
  'zend_mm_custom_handlers.c',
)

shared_module(
    'zend_test',
    [ext_zend_test_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
