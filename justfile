# user-configurable variables

# must match one of the directories under platform/
platform := env('PLATFORM')

# The install prefix.  Override it on the command line (`just prefix=/path ...`)
# or via the PUNK_INSTALL_PREFIX environment variable; it is re-exported as
# PUNK_INSTALL_PREFIX so every recipe's child process can read it too.
prefix := env('PUNK_INSTALL_PREFIX', '/opt/punk')
export PUNK_INSTALL_PREFIX := prefix

# internal variables
# platform_dir := justfile_directory() / 'platform' / platform
platform_dir := 'platform' / platform
meson_build_dir := platform_dir / '.meson-build'

# The fuzzer cannot share a configuration with the build above -- it is not ZTS,
# everything in it is instrumented, and it links the core statically -- so it
# gets a build directory of its own (sapi/fuzzer/meson.build has the details).
fuzzer_build_dir := platform_dir / '.meson-build-fuzzer'

# Which sanitizers the fuzzer build links against, passed to meson as
# b_sanitize.  Override it the same way (`just fuzz_sanitize=undefined fuzzer`);
# -fsanitize=fuzzer-no-link is added on top by the build itself, so this is only
# the part that finds bugs.  address is the one the README leads with and the
# fastest; address,undefined catches more.
fuzz_sanitize := env('PUNK_FUZZ_SANITIZE', 'address')

shell := platform_dir / "shell"

list:
    just --list

all: setup compile meson-tests test install

setup: _wipe-build
    {{shell}} meson setup --prefix {{prefix}} --libdir {{prefix}}/lib {{meson_build_dir}}

compile:
    {{shell}} meson compile -C {{meson_build_dir}}

meson-tests:
    {{shell}} meson test -C {{meson_build_dir}} --print-errorlogs

test *TESTS:
    -{{shell}} scripts/dev/run-phpt-suite {{meson_build_dir}}/sapi/cli/punk {{TESTS}}

install: _wipe-install
    {{shell}} meson install -C {{meson_build_dir}}

# mostly for cleaning tests -- source dirs should normally be unchanged
clean:
    rm -rf actmp.* modules
    git status --porcelain --ignored | egrep '^!! (ext|main|sapi|TSRM|Zend|scripts|tests)/' | cut -c3- | xargs rm -rf

_wipe-build:
    rm -rf {{meson_build_dir}}

_wipe-install:
    {{shell}} bash -c '[ -n {{prefix}} ] && rm -rf {{prefix}}/*'

#### Fuzzer SAPI

# builds fuzzer sapi in separate build dir
fuzzer: _fuzzer-setup _fuzzer-compile

_fuzzer-setup: _wipe-fuzzer-build
    {{shell}} meson setup -Dfuzzer=true -Dzts=false -Db_sanitize={{fuzz_sanitize}} --prefix {{prefix}}/fuzzer {{fuzzer_build_dir}}

_fuzzer-compile:
    {{shell}} meson compile -C {{fuzzer_build_dir}} fuzzer

_wipe-fuzzer-build:
    rm -rf {{fuzzer_build_dir}}

#### miscellany

# open an interactive shell in the platform environment
shell:
    {{shell}} bash

# runs the test suite on the globally installed punk instead of the built one
test-installed *TESTS:
    {{shell}} scripts/dev/run-phpt-suite {{prefix}}/bin/php {{TESTS}}

# rebuild docker image for the current platform
build-image:
    #!/usr/bin/env bash
    set -euo pipefail
    cd {{platform_dir}} && docker compose build

# run various checks against the punk build and/or install
distcheck: _check-modules _check-install _check-phpize

# load every module built by `just all` and report the ones that fail
_check-modules:
    {{shell}} scripts/dev/check-modules {{meson_build_dir}}

# test that the installed punk is usable from outside
_check-install:
    {{shell}} scripts/dev/check-install {{prefix}}

# check that the installed phpize can faithfully build an autoconf-based extension
_check-phpize:
    {{shell}} scripts/dev/check-phpize {{prefix}}

