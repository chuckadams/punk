# user-configurable variables
# The install prefix.  Override it on the command line (`just prefix=/path ...`)
# or via the PUNK_INSTALL_PREFIX environment variable; it is re-exported as
# PUNK_INSTALL_PREFIX so every recipe's child process can read it too.
prefix := env('PUNK_INSTALL_PREFIX', '/opt/punk')
export PUNK_INSTALL_PREFIX := prefix

# Which sanitizers the fuzzer build links against, passed to meson as
# b_sanitize.  Override it the same way (`just fuzz_sanitize=undefined fuzzer`);
# -fsanitize=fuzzer-no-link is added on top by the build itself, so this is only
# the part that finds bugs.  address is the one the README leads with and the
# fastest; address,undefined catches more.
fuzz_sanitize := env('PUNK_FUZZ_SANITIZE', 'address')

platform := env('PLATFORM')

# internal variables
# platform_dir := justfile_directory() / 'platform' / platform
platform_dir := 'platform' / platform
meson_build_dir := platform_dir / '.meson-build'
# The fuzzer cannot share a configuration with the build above -- it is not ZTS,
# everything in it is instrumented, and it links the core statically -- so it
# gets a build directory of its own (sapi/fuzzer/meson.build has the details).
fuzzer_build_dir := platform_dir / '.meson-build-fuzzer'

shell := platform_dir / "shell"

list:
    just --list

# open an interactive shell in the platform environment
shell:
    {{shell}} bash

# to-do list
# * various *dbm packages (except gdbm, which is GPL)
# * support odbc (it builds, but fails many tests)
# * support pdo_dblib (it builds, but its tests crash the whole test suite)
# * mysqli and mysqlnd both fail to load when built as shared.  fix this.
# * an option for which extensions are static, so the fuzzer build can be
#   minimal and the exif/mbstring/mbregex fuzzers can link
# * gcov, valgrind support

# things punk will never support
# litespeed           (proprietary)
# gdbm                (GPL)
# ibm-db2             (proprietary)
# mhash               (deprecated for good reasons)
# mm                  (literally has syntax errors in the source code!)
# pear                (deprecated, client can be downloaded manually)
# readline            (GPL)

# what meson builds unconditionally: the five front-ends (cli cgi embed fpm
# phpdbg) and every extension with a meson.build.  autoconf's --disable-all and
# per-extension =shared flags are gone with it; meson.options has the build
# variants that are left.

# run the .phpt suite against the build directory's binary, optionally limited
# to individual tests or directories:
#   just test Zend/tests/foo.phpt
# failure is ignored so that `just meson` still installs a build that has
# failing tests -- read the summary
test *TESTS:
    -{{shell}} scripts/dev/run-phpt-suite {{meson_build_dir}}/sapi/cli/punk {{TESTS}}

# run the .phpt suite against the installed binary (see `just meson`):
#   just test-installed ext/curl/tests
test-installed *TESTS:
    {{shell}} scripts/dev/run-phpt-suite {{prefix}}/bin/punk {{TESTS}}

clean:
    rm -rf actmp.* modules
    git status --porcelain --ignored | egrep '^!! (ext|main|sapi|TSRM|Zend|scripts|tests)/' | cut -c3- | xargs rm -rf

# rebuild the platform's docker image after changing its Dockerfile
# runs on the host: the image can't be rebuilt from inside itself
build-image:
    #!/usr/bin/env bash
    set -euo pipefail
    cd {{platform_dir}} && docker compose build

# load every module built by `just meson` and report the ones that fail
check-modules:
    {{shell}} scripts/dev/check-modules {{meson_build_dir}}

# check that the installed punk is usable from outside: php-config's answers,
# the installed headers compiling an out-of-tree module, and every header of the
# directories installed wholesale being present
check-install:
    {{shell}} scripts/dev/check-install {{prefix}}

# prove the installed phpize and the payload it copies still build a third-party
# extension the autoconf way.  Skipped, not failed, where autoconf/make are
# absent -- punk's own build must not need them.
check-phpize:
    {{shell}} scripts/dev/check-phpize {{prefix}}

meson: _meson-setup _meson-compile test _meson-install check-phpize

# rebuild in place -- no wipe, no install
meson-rebuild: _meson-compile

# not the .phpt suite -- that is `just test` / `just test-installed`
# run meson's own test() targets: one smoke test per front-end
unit-test:
    {{shell}} meson test -C {{meson_build_dir}} --print-errorlogs

_meson-setup: _wipe-build
    {{shell}} meson setup --prefix {{prefix}} --libdir {{prefix}}/lib {{meson_build_dir}}

_meson-compile:
    {{shell}} meson compile -C {{meson_build_dir}}

# the fuzzer's build directory is separate from the main one (see
# fuzzer_build_dir above), and nothing is installed or tested
# build the Clang fuzzing SAPI and its fuzzers
fuzzer: _fuzzer-setup _fuzzer-compile

# the sanitizers are fuzz_sanitize's; the rest is what the fuzzer needs and the
# normal build cannot have.  The prefix is only here so that a stray
# `meson install` cannot land an instrumented tree on top of the real one.
_fuzzer-setup: _wipe-fuzzer-build
    {{shell}} meson setup -Dfuzzer=true -Dzts=false -Db_sanitize={{fuzz_sanitize}} --prefix {{prefix}}/fuzzer {{fuzzer_build_dir}}

# the 'fuzzer' alias target, so this builds the fuzzers rather than the whole
# build directory -- which also describes the front-ends and the modules
_fuzzer-compile:
    {{shell}} meson compile -C {{fuzzer_build_dir}} fuzzer

_meson-install: _wipe-install
    {{shell}} meson install -C {{meson_build_dir}}

_wipe-build:
    rm -rf {{meson_build_dir}}

_wipe-fuzzer-build:
    rm -rf {{fuzzer_build_dir}}

# the prefix lives inside the container / platform environment, so this has to
# run through the platform shell rather than on the host
_wipe-install:
    {{shell}} bash -c '[ -n {{prefix}} ] && rm -rf {{prefix}}/*'
