# The fuzzing SAPI (--enable-fuzzer).  It is not one front-end but a set of them:
# fuzzer-sapi.c, which boots the engine and runs one request at a time, plus one
# LLVMFuzzerTestOneInput per fuzzer, each linked into its own binary.  The root
# meson.build only enters this directory with -Dfuzzer=true, and it has to be
# built in a build directory of its own, for three reasons that are all
# structural rather than tidiness:
#
#   * config.m4 refuses --enable-fuzzer together with --enable-zts ("Thread
#     safety is not supported when building fuzzing module"), and punk is ZTS by
#     default, so the fuzzer build configures -Dzts=false.  php_config.h is one
#     per build directory, so there is no way to have both in the same one.
#   * the root meson.build adds -fsanitize=fuzzer-no-link to every compilation
#     when this option is on, and the sanitizers come from -Db_sanitize; neither
#     belongs in the binary punk normally ships.
#   * the fuzzers link the static core, so an extension they call into has to be
#     linked in rather than loaded.  That is what keeps the exif, mbstring and
#     mbregex fuzzers out for now -- see below.
#
# `just fuzzer` sets all of that up; the option's description in meson.options
# has the configure line on its own.

# One compilation of the core, shared by every fuzzer.  All the fuzzers link the
# same object files in the autoconf build too ($(PHP_GLOBAL_OBJS) and
# $(PHP_BINARY_OBJS)), and that is not just economy here: meson compiles sources
# per target, and the core is 400-odd objects, so listing its sources in each of
# the fuzzer executables would compile them once per fuzzer.
sapi_fuzzer_core = static_library(
    'fuzzer_core',
    # ext/standard/basic_functions.c includes <zend_language_parser.h> and
    # ext/opcache includes zend_vm_opcodes.h, both generated in Zend/; listing
    # them as sources orders the generators before this target compiles.
    [punk_frontend_sources, files('fuzzer-sapi.c'),
     zend_language_parser_gen[1], zend_vm_gen[0], punk_frontend_arginfo],
    c_args : static_c_args,
    # The core includes headers from the libraries the front-ends link (libxml2
    # through php_libxml.h, icu, zlib, ...), so a static library still needs the
    # front-end dependencies for their include paths.
    dependencies : punk_frontend_dependencies,
    include_directories : [includes],
)

# The fuzzers config.m4 defines unconditionally, in its order.  function-jit and
# tracing-jit are the two whose subject is not linked in: they only set
# opcache.jit through ini, and this port builds opcache without the JIT, so they
# run the interpreter just as php-fuzz-execute does.  They are still built,
# because that is what config.m4 does and they are what to run once the JIT is
# switched on.
#
# php-fuzz-exif, php-fuzz-mbstring and php-fuzz-mbregex are deliberately absent.
# config.m4 defines them when the extension is enabled, and punk enables both of
# them -- as shared modules, which these fuzzers cannot use: fuzzer-mbstring.c
# calls mb_convert_buf() and its neighbours directly, so it would not even link,
# and the other two look their function up in the function table and assert that
# it was found, so an exif or mbstring that is not linked in makes them abort on
# their first input.  Building them needs the option for a static extension set
# that this port does not have yet.
sapi_fuzzer_targets = [
    'parser',
    'execute',
    'function-jit',
    'tracing-jit',
    'unserialize',
    'unserializehash',
    'json',
]

sapi_fuzzer_exes = []
foreach target : sapi_fuzzer_targets
    sapi_fuzzer_exes += executable(
        'php-fuzz-' + target,
        'fuzzer-' + target + '.c',
        c_args : static_c_args,
        dependencies : punk_frontend_dependencies,
        include_directories : [includes, '.'],
        # link_whole, not link_with: the core is a pile of objects that register
        # themselves on startup, and nothing refers to them by name.
        link_whole : [sapi_fuzzer_core, punk_frontend_link_whole],
        # -fsanitize=fuzzer is what supplies LLVMFuzzerTestOneInput's caller --
        # libFuzzer's main -- and the link-time half of the instrumentation the
        # root meson.build adds to every compilation.
        link_args : ['-fsanitize=fuzzer'],
        export_dynamic : true,
    )
endforeach

# `meson compile -C <build dir> fuzzer` builds exactly the fuzzers.  That is what
# `just fuzzer` asks for, rather than the whole build directory, because this
# configuration also describes the front-ends and the fifty modules and none of
# them is needed here.
alias_target('fuzzer', sapi_fuzzer_exes)
