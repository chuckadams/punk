re2c = find_program('re2c')
bison = find_program('bison')

json_scanner_gen = custom_target(
    'json_scanner',
    input: 'json_scanner.re',
    output: ['json_scanner.c', 'php_json_scanner_defs.h'],
    command: [re2c, '--no-generation-date', '-W', '-g', '-t', '@OUTPUT1@', '-bci', '-o', '@OUTPUT0@', '@INPUT@'],
)

json_parser_gen = custom_target(
    'json_parser',
    input: 'json_parser.y',
    output: ['json_parser.tab.c', 'json_parser.tab.h'],
    command: [bison, '-Wall', '--defines', '-l', '@INPUT@', '-o', '@OUTPUT0@'],
)

ext_json_sources = files(
    'json.c',
    'json_encoder.c',
) + [json_parser_gen[0], json_scanner_gen[0]]

if not cli_static_extensions.contains('json')
    shared_module(
        'json',
        [ext_json_sources],
        name_prefix: '',
        c_args : [],
        include_directories : [includes],
        install : true,
    )
endif

install_headers(
    'php_json.h',
    'php_json_parser.h',
    'php_json_scanner.h',
    subdir: 'php/ext/json',
)