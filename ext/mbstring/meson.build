ext_mbstring_sources = files(
  'libmbfl/filters/html_entities.c',
  'libmbfl/filters/mbfilter_7bit.c',
  'libmbfl/filters/mbfilter_base64.c',
  'libmbfl/filters/mbfilter_cjk.c',
  'libmbfl/filters/mbfilter_htmlent.c',
  'libmbfl/filters/mbfilter_qprint.c',
  'libmbfl/filters/mbfilter_singlebyte.c',
  'libmbfl/filters/mbfilter_ucs2.c',
  'libmbfl/filters/mbfilter_ucs4.c',
  'libmbfl/filters/mbfilter_utf16.c',
  'libmbfl/filters/mbfilter_utf32.c',
  'libmbfl/filters/mbfilter_utf7.c',
  'libmbfl/filters/mbfilter_utf7imap.c',
  'libmbfl/filters/mbfilter_utf8.c',
  'libmbfl/filters/mbfilter_uuencode.c',
  'libmbfl/mbfl/mbfilter.c',
  'libmbfl/mbfl/mbfilter_8bit.c',
  'libmbfl/mbfl/mbfilter_pass.c',
  'libmbfl/mbfl/mbfilter_wchar.c',
  'libmbfl/mbfl/mbfl_convert.c',
  'libmbfl/mbfl/mbfl_encoding.c',
  'libmbfl/mbfl/mbfl_filter_output.c',
  'libmbfl/mbfl/mbfl_language.c',
  'libmbfl/mbfl/mbfl_memory_device.c',
  'libmbfl/mbfl/mbfl_string.c',
  'libmbfl/nls/nls_de.c',
  'libmbfl/nls/nls_en.c',
  'libmbfl/nls/nls_hy.c',
  'libmbfl/nls/nls_ja.c',
  'libmbfl/nls/nls_kr.c',
  'libmbfl/nls/nls_neutral.c',
  'libmbfl/nls/nls_ru.c',
  'libmbfl/nls/nls_tr.c',
  'libmbfl/nls/nls_ua.c',
  'libmbfl/nls/nls_uni.c',
  'libmbfl/nls/nls_zh.c',
  'mb_gpc.c',
  'mbstring.c',
  'php_mbregex.c',
  'php_unicode.c',
)

shared_module(
    'mbstring',
    [ext_mbstring_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes, 'libmbfl', 'libmbfl/mbfl'],
    dependencies: [],
    install : true,
)


install_headers(
  'mbstring.h',
  'php_mbregex.h',
  'php_onig_compat.h',
  subdir: 'ext/mbstring',
)


install_headers(
  'libmbfl/config.h',
  subdir: 'ext/mbstring/libmbfl',
)


install_headers(
  'libmbfl/mbfl/eaw_table.h',
  'libmbfl/mbfl/mbfilter.h',
  'libmbfl/mbfl/mbfilter_8bit.h',
  'libmbfl/mbfl/mbfilter_pass.h',
  'libmbfl/mbfl/mbfilter_wchar.h',
  'libmbfl/mbfl/mbfl_consts.h',
  'libmbfl/mbfl/mbfl_convert.h',
  'libmbfl/mbfl/mbfl_defs.h',
  'libmbfl/mbfl/mbfl_encoding.h',
  'libmbfl/mbfl/mbfl_filter_output.h',
  'libmbfl/mbfl/mbfl_language.h',
  'libmbfl/mbfl/mbfl_memory_device.h',
  'libmbfl/mbfl/mbfl_string.h',
  subdir: 'ext/mbstring/libmbfl/mbfl',
)
