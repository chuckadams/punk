nproc := env('NPROC', '1')
platform := env('PLATFORM')
platform_dir := justfile_directory() / 'platform' / platform

list:
    just --list

all: rebuild install test

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

# extensions built with --disable-all: date hash json lexbor opcache pcre random reflection spl standard uri
# sapis built by default: cli cgi phpdbg

make:
    make -j{{nproc}}

test:
    -TEST_PHP_ARGS='-q -j{{nproc}}' make test

install:
    make install

clean:
    rm -rf autom4te.cache configure actmp.* config.* Makefile Makefile.* libtool
    rm -f {{platform_dir}}/config.cache
    git status --porcelain --ignored | egrep '^!! (ext|main|sapi|TSRM|Zend|scripts|tests)/' | cut -c3- | xargs rm -rf
