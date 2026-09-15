tmp_methods_arginfo_gen = custom_target(
    'tmp_methods_arginfo',
    input: 'tmp_methods.stub.php',
    output: [ 'tmp_methods_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

object_handlers_arginfo_gen = custom_target(
    'object_handlers_arginfo',
    input: 'object_handlers.stub.php',
    output: [ 'object_handlers_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

fiber_arginfo_gen = custom_target(
    'fiber_arginfo',
    input: 'fiber.stub.php',
    output: [ 'fiber_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

test_arginfo_gen = custom_target(
    'test_arginfo',
    input: 'test.stub.php',
    output: [ 'test_arginfo.h', 'test_decl.h', 'test_legacy_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

iterators_arginfo_gen = custom_target(
    'iterators_arginfo',
    input: 'iterators.stub.php',
    output: [ 'iterators_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

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
    [ext_zend_test_sources, tmp_methods_arginfo_gen[0], object_handlers_arginfo_gen[0], fiber_arginfo_gen[0], test_arginfo_gen[0], test_arginfo_gen[1], test_arginfo_gen[2], iterators_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('libxml-2.0')],
    install : true,
)
