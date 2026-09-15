sapi_embed_sources = files(
    'php_embed.c',
)

# libphp is the embeddable PHP: a shared library a host program links against
# (--enable-embed=shared).  It carries the same core as the CLI executable, plus
# the CLI's non-main objects, because php_embed builds on do_php_cli()'s
# implementation -- config.m4 links PHP_CLI_SHARED_OBJS into it for the same
# reason.
libphp = shared_library(
    'php',
    # ext/standard/basic_functions.c includes <zend_language_parser.h> and
    # ext/opcache includes zend_vm_opcodes.h, both generated in Zend/; listing
    # them as sources orders the generators before this target compiles.
    [punk_frontend_sources, sapi_embed_sources, sapi_cli_shared_sources,
     zend_language_parser_gen[1], zend_vm_gen[0],
     php_cli_process_title_arginfo_gen[0], php_cli_server_arginfo_gen[0], punk_frontend_arginfo],
    c_args : static_c_args,
    dependencies : punk_frontend_dependencies,
    include_directories : [includes, '.', sapi_cli_includes],
    link_whole : punk_frontend_link_whole,
    install : true,
)

install_headers(
    'php_embed.h',
    subdir : 'php/sapi/embed',
)

# A host program that embeds PHP and checks the result, so `meson test` covers
# libphp the way the CLI test covers the punk executable.  It links the library
# rather than the sources, which is what a real embedder does.
embed_basic_exe = executable(
    'embed_basic',
    'tests/embed_basic.c',
    include_directories : [includes, '.'],
    link_with : libphp,
)

test('sapi_embed_test_basic', embed_basic_exe)
