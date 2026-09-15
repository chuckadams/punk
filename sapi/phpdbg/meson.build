# phpdbg, the interactive debugger.  It is the only front-end that carries a
# command language of its own, so it also carries a lexer and a parser that re2c
# and bison generate.  `just generate` does not cover them for autoconf --
# sapi/phpdbg/Makefile.frag does, driven by scripts/dev/genfiles -- and that is
# the invocation reproduced here, flags included.
re2c = find_program('re2c')
bison = find_program('bison')

phpdbg_lexer_gen = custom_target(
    'phpdbg_lexer',
    input : 'phpdbg_lexer.l',
    output : 'phpdbg_lexer.c',
    # -F is --flex-syntax, which phpdbg_lexer.l is written in, and -i suppresses
    # the #line directives in the output.  The generated lexer #includes the
    # parser header bison writes next to it, so both targets are listed as
    # sources below and ninja orders them first.
    command : [re2c, '--no-generation-date', '-i', '-W', '-cbdFo', '@OUTPUT@', '@INPUT@'],
)

phpdbg_parser_gen = custom_target(
    'phpdbg_parser',
    input : 'phpdbg_parser.y',
    output : ['phpdbg_parser.c', 'phpdbg_parser.h'],
    command : [bison, '-Wall', '-v', '-d', '@INPUT@', '-o', '@OUTPUT0@'],
)

phpdbg_arginfo_gen = custom_target('phpdbg_arginfo', input: 'phpdbg.stub.php', output: 'phpdbg_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php])

sapi_phpdbg_sources = files(
    'phpdbg.c',
    'phpdbg_bp.c',
    'phpdbg_break.c',
    'phpdbg_btree.c',
    'phpdbg_cmd.c',
    'phpdbg_frame.c',
    'phpdbg_help.c',
    'phpdbg_info.c',
    'phpdbg_io.c',
    'phpdbg_list.c',
    'phpdbg_out.c',
    'phpdbg_print.c',
    'phpdbg_prompt.c',
    'phpdbg_set.c',
    'phpdbg_sigsafe.c',
    'phpdbg_utils.c',
    'phpdbg_watch.c',
)

phpdbg_exe = executable(
    'phpdbg',
    # ext/standard/basic_functions.c includes <zend_language_parser.h> and
    # ext/opcache includes zend_vm_opcodes.h, both generated in Zend/; listing
    # them as sources orders the generators before this target compiles.
    [punk_frontend_sources, sapi_phpdbg_sources, phpdbg_lexer_gen, phpdbg_parser_gen,
     zend_language_parser_gen[1], zend_vm_gen[0], phpdbg_arginfo_gen[0], punk_frontend_arginfo],
    c_args : static_c_args,
    # The front-end dependencies are what phpdbg needs to run the engine; libedit
    # rides along in them for ext/readline, which phpdbg does not call into while
    # HAVE_PHPDBG_READLINE is off.  config.m4's PHPDBG_EXTRA_LIBS carried the
    # readline libraries for the opposite reason.
    dependencies : punk_frontend_dependencies,
    # The generated lexer and parser land in this directory's build dir, next to
    # the arginfo header phpdbg.c includes by bare name.
    include_directories : [includes, '.'],
    link_whole : punk_frontend_link_whole,
    export_dynamic : true,
    install : true,
)

# A smoke test of the built binary for `just unit-test`: -V prints the banner and
# exits, which starts the engine, registers the SAPI and tears it down again.
# (-v is phpdbg's "disable quietness", not its version flag.)
test('sapi_phpdbg_test_version', phpdbg_exe, args : ['-n', '-V'])

phpdbg_conf_data = configuration_data()
phpdbg_conf_data.set('PHP_VERSION', php_version)
# configure's --program-prefix, which the meson build does not use: phpdbg is
# installed under that name, as get_binary() in run-tests.php looks for.
phpdbg_conf_data.set('program_prefix', '')

phpdbg_1 = configure_file(input : 'phpdbg.1.in', output : 'phpdbg.1', configuration : phpdbg_conf_data)

install_man(phpdbg_1)
