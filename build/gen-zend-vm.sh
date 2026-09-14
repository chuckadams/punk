#!/bin/sh
# Generate the Zend VM files into a build directory.
#
# zend_vm_gen.php writes into its own directory (__DIR__) and reads its inputs
# from there, so meson copies the script and its inputs into the build directory
# and runs the copy -- the outputs then land in the build directory instead of
# the source tree.  build/regenerate runs the same script in place for autoconf,
# where the outputs are needed next to the sources.
#
# $1 = source Zend directory, $2 = output (build) directory.
set -eu

src="$1"
out="$2"

mkdir -p "$out"
cp "$src/zend_vm_gen.php" "$src/zend_vm_def.h" "$src/zend_vm_execute.skl" "$out/"
[ -f "$src/zend_vm_order.txt" ] && cp "$src/zend_vm_order.txt" "$out/"

cd "$out"
php zend_vm_gen.php
