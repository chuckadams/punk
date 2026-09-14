ext_tokenizer_sources = files(
  'tokenizer.c',
  'tokenizer_data.c',
)

shared_module(
    'tokenizer',
    # tokenizer.c includes Zend/zend_language_scanner_defs.h and both sources
    # include Zend/zend_language_parser.h, generated in Zend/; listing the
    # headers as sources makes ninja build the generators first.
    [ext_tokenizer_sources, zend_language_parser_gen[1], zend_language_scanner_gen[1]],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
    dependencies: [],
    install : true,
)
