nproc := env('NPROC', '1')
platform := env('PLATFORM')
platform_dir := 'platform' / platform

list:
    just --list

all: rebuild test

rebuild: clean configure make

configure:
    ./buildconf --force
    ./configure \
        --cache-file="{{platform_dir}}/config.cache" \
        --prefix=/opt/punk \
        --disable-all \
        --enable-debug \
        --enable-zts \
        --enable-cli

make:
    make -j{{nproc}}

test:
    -TEST_PHP_ARGS='-q -j{{nproc}}' make test

clean: _clean_autoconf _clean_platform
    find . \( -name '*.o' -or -name '*.la' -or -name '*.lo' -or -name '*.1' -or -name '*.8' \) -print0 | xargs -0 rm -f
    rm -rf modules libs
    rm -f sapi/cli/php sapi/cgi/php-cgi
    rm -f ext/date/lib/timelib_config.h ext/mbstring/libmbfl/config.h
    rm -f sapi/cli/php
    cd ext/opcache/jit/ir && rm -f gen_ir_fold_hash minilua ir_fold_hash.h ir_emit_x86.h ir_emit_aarch64.h
    cd main && rm -f php_config.h build-defs.h internal_functions_cli.c internal_functions.c
    cd Zend && rm -f zend_dtrace_gen.h zend_dtrace_gen.h.bak zend_config.h
    cd sapi/fpm && rm -f php-fpm.conf init.d.php-fpm php-fpm.service status.html
    cd scripts && rm -f phpize php-config
    cd ext/phar && rm -f phar.php phar.phar

_clean_autoconf:
    rm -rf autom4te.cache configure config.* Makefile Makefile.* libtool

_clean_platform:
    # rm -f {{platform_dir}}/config.cache
