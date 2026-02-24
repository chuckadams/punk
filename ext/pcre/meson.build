# EXTRA_FLAGS="-I./ext/pcre -Wno-implicit-fallthrough -DHAVE_CONFIG_H -DHAVE_MEMMOVE" cc_ \
ext_pcre_sources = files(
    'php_pcre.c',

# we use --with-external-pcre now
#    'pcre2lib/pcre2_auto_possess.c',
#    'pcre2lib/pcre2_chartables.c',
#    'pcre2lib/pcre2_chkdint.c',
#    'pcre2lib/pcre2_compile.c',
#    'pcre2lib/pcre2_config.c',
#    'pcre2lib/pcre2_context.c',
#    'pcre2lib/pcre2_convert.c',
#    'pcre2lib/pcre2_dfa_match.c',
#    'pcre2lib/pcre2_error.c',
#    'pcre2lib/pcre2_extuni.c',
#    'pcre2lib/pcre2_find_bracket.c',
#    'pcre2lib/pcre2_jit_compile.c',
#    'pcre2lib/pcre2_maketables.c',
#    'pcre2lib/pcre2_match_data.c',
#    'pcre2lib/pcre2_match.c',
#    'pcre2lib/pcre2_newline.c',
#    'pcre2lib/pcre2_ord2utf.c',
#    'pcre2lib/pcre2_pattern_info.c',
#    'pcre2lib/pcre2_script_run.c',
#    'pcre2lib/pcre2_serialize.c',
#    'pcre2lib/pcre2_string_utils.c',
#    'pcre2lib/pcre2_study.c',
#    'pcre2lib/pcre2_substitute.c',
#    'pcre2lib/pcre2_substring.c',
#    'pcre2lib/pcre2_tables.c',
#    'pcre2lib/pcre2_ucd.c',
#    'pcre2lib/pcre2_valid_utf.c',
#    'pcre2lib/pcre2_xclass.c',
)

ext_pcre_objs = static_library(
    'ext_pcre_objs',
    ext_pcre_sources,
    c_args: ['-DHAVE_CONFIG_H', '-DHAVE_MEMMOVE'],
    include_directories: [includes],
    dependencies: [dependency('libpcre2-8')],
    build_by_default: false,
)

shared_module(
    'pcre',
    [ext_pcre_sources],
    name_prefix: '',
    c_args: ['-DHAVE_CONFIG_H', '-DHAVE_MEMMOVE'],
    include_directories : [includes],
    dependencies: [dependency('libpcre2-8')],
    install : true,
)
