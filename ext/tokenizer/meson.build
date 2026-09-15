tokenizer_data_arginfo_gen = custom_target(
    'tokenizer_data_arginfo',
    input: 'tokenizer_data.stub.php',
    output: [ 'tokenizer_data_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

tokenizer_arginfo_gen = custom_target(
    'tokenizer_arginfo',
    input: 'tokenizer.stub.php',
    output: [ 'tokenizer_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_tokenizer_sources = files(
  'tokenizer.c',
  'tokenizer_data.c',
)

shared_module(
    'tokenizer',
    # tokenizer.c includes Zend/zend_language_scanner_defs.h and both sources
    # include Zend/zend_language_parser.h, generated in Zend/; listing the
    # headers as sources makes ninja build the generators first.
    [ext_tokenizer_sources, zend_language_parser_gen[1], zend_language_scanner_gen[1], tokenizer_data_arginfo_gen[0], tokenizer_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [],
    install : true,
)
