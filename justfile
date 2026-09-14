# user-configurable variables
prefix := '/opt/punk'
nproc := env('NPROC', num_cpus())
platform := env('PLATFORM')
sapi := env('BUILD_SAPI', 'cli')

# internal variables
# platform_dir := justfile_directory() / 'platform' / platform
platform_dir := 'platform' / platform
meson_build_dir := platform_dir / '.meson-build'

shell := platform_dir / "shell"

list:
    just --list

# open an interactive shell in the platform environment
shell:
    {{shell}} bash

all: rebuild install test

rebuild: clean configure generate make

configure:
    {{shell}} ./buildconf --force
    {{shell}} {{platform_dir}}/configure


# to-do list
# * various *dbm packages (except gdbm, which is GPL)
# * support odbc (it builds, but fails many tests)
# * support pdo_dblib (it builds, but its tests crash the whole test suite)
# * mysqli and mysqlnd both fail to load when built as shared.  fix this.
# * fuzzer sapi
# * gcov, valgrind support

# things punk will never support
# --enable-litespeed  (proprietary)
# --with-gdbm         (GPL)
# --with-ibm-db2      (proprietary)
# --with-mhash        (deprecated for good reasons)
# --with-mm           (literally has syntax errors in the source code!)
# --with-pear         (deprecated, client can be downloaded manually)
# --with-readline     (GPL)

# extensions built with --disable-all: date hash json lexbor opcache pcre random reflection spl standard uri
# sapis built by default: cli cgi phpdbg

generate:
    {{shell}} build/regenerate

make:
    {{shell}} make -j{{nproc}}

# run the test suite, optionally limited to individual tests or directories:
#   just test Zend/tests/foo.phpt
test *TESTS:
    -{{shell}} make test TESTS="{{TESTS}}"

# run the .phpt suite against the installed binary (see `just meson`), without make:
#   just test-installed ext/curl/tests
test-installed *TESTS:
    {{shell}} scripts/dev/run-phpt-suite {{prefix}}/bin/punk {{TESTS}}

install: _wipe-install
    {{shell}} make install
    {{shell}} bash -c 'find {{prefix}}/lib/php/extensions/* -type f'

clean:
    rm -rf {{platform_dir}}/config.cache autom4te.cache .libs modules configure actmp.* config.* Makefile Makefile.* libtool
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
# the installed headers compiling an out-of-tree module, and the header
# directories autoconf installed wholesale being complete
check-install:
    {{shell}} scripts/dev/check-install {{prefix}}

# how much of autoconf's config header meson reproduces yet; exits non-zero
# while the two differ, so it can gate the switch to meson's header
compare-config:
    {{shell}} scripts/dev/compare-config-headers main/php_config.h {{meson_build_dir}}/main/php_config.h

meson: _meson-setup _meson-compile _meson-test _meson-install

# rebuild in place -- no wipe, no install
meson-rebuild: _meson-compile

_meson-setup: _wipe-build
    {{shell}} meson setup --prefix {{prefix}} --libdir {{prefix}}/lib {{meson_build_dir}}

_meson-compile:
    {{shell}} meson compile -C {{meson_build_dir}}

# test the binaries in the build directory, without installing them first:
#   just _meson-test Zend/tests
# failure is ignored so that `just meson` still installs a build that has
# failing tests -- read the summary
_meson-test *TESTS:
    -{{shell}} scripts/dev/run-phpt-suite {{meson_build_dir}}/sapi/cli/punk {{TESTS}}

_meson-install: _wipe-install
    {{shell}} meson install -C {{meson_build_dir}}

_wipe-build:
    rm -rf {{meson_build_dir}}

# the prefix lives inside the container / platform environment, so this has to
# run through the platform shell rather than on the host
_wipe-install:
    {{shell}} bash -c '[ -n {{prefix}} ] && rm -rf {{prefix}}/*'
