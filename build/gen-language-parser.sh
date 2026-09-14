#!/bin/sh
# Generate Zend/zend_language_parser.c/.h from the .y, then make zendparse
# exported.  meson calls this with three arguments -- the .y input and the two
# outputs -- and build/regenerate contains the same two commands inline for the
# autoconf build.
set -eu

bison -Wall -v -d "$1" -o "$2"
perl -pi -e 's/^int zendparse/ZEND_API int zendparse/g' "$2" "$3"
