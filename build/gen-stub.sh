#!/bin/sh
# Generate arginfo headers from a .stub.php into a build directory.
#
# gen_stub.php writes its outputs next to the input .stub.php, so meson copies
# the stub into the build directory and runs the *source* gen_stub.php on the
# copy; the outputs (foo_arginfo.h and, when the stub asks for them, foo_decl.h
# and foo_legacy_arginfo.h) then land in the build directory.  gen_stub.php
# self-bootstraps its PHP-Parser dependency into build/PHP-Parser-*, which is
# gitignored, so running the source copy keeps that shared and out of the tree.
#
# $1 = source .stub.php, $2 = output (build) directory, $3 = source gen_stub.php
set -eu

stub="$1"
out="$2"
gen="$3"
name=$(basename "$stub")

cp "$stub" "$out/$name"
cd "$out"
php "$gen" "$name"
