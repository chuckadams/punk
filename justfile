nproc := env('NPROC', num_cpus())
platform := env('PLATFORM')
sapi := env('BUILD_SAPI', 'cli')

platform_dir := justfile_directory() / 'platform' / platform
install_dir := env('PUNK_INSTALL_DIR', '/opt/punk')

# not supported yet -- a number of extensions won't build statically
# shared := if env('BUILD_STATIC', 'no') == 'no' { "shared" } else { "static" }
shared := "shared"

list:
    just --list

all: rebuild install test

rebuild: clean configure make

configure:
    ./buildconf --force
    ./configure \
        --cache-file="{{platform_dir}}/config.cache" \
        --prefix={{install_dir}} \
        --disable-all \
        --enable-debug \
        --enable-re2c-cgoto \
        --enable-sigchild \
        \
        $(just _sapi_{{sapi}}) \
        \
        --with-libedit \
        --enable-intl \
        --with-mysqli \
        --enable-mysqlnd \
        --with-openssl={{shared}} \
        --with-openssl-argon2 \
        --with-sqlite3={{shared}} \
        --with-zlib={{shared}} \
        --enable-bcmath={{shared}} \
        --with-bz2={{shared}} \
        --enable-calendar={{shared}} \
        --enable-ctype={{shared}} \
        --with-curl={{shared}} \
        --enable-dba={{shared}} \
        --enable-dl-test={{shared}} \
        --enable-dom={{shared}} \
        --with-enchant={{shared}} \
        --enable-exif={{shared}} \
        --with-ffi={{shared}} \
        --enable-fileinfo={{shared}} \
        --enable-filter={{shared}} \
        --enable-ftp={{shared}} \
        --enable-gd={{shared}} \
            --with-avif \
            --with-webp \
            --with-jpeg \
            --with-xpm \
            --with-freetype \
        --with-gettext={{shared}} \
        --with-gmp={{shared}} \
        --with-iconv={{shared}} \
        --with-ldap={{shared}} \
        --with-ldap-sasl \
        --enable-mbstring={{shared}} \
        --with-iodbc={{shared}} \
        --enable-pcntl={{shared}} \
        --enable-pdo={{shared}} \
        --with-pdo-firebird={{shared}} \
        --with-pdo-mysql={{shared}} \
        --with-pdo-odbc=shared,iODBC \
        --with-pdo-pgsql={{shared}} \
        --with-pdo-sqlite={{shared}} \
        --with-pgsql={{shared}} \
        --enable-phar={{shared}} \
        --enable-posix={{shared}} \
        --enable-session={{shared}} \
        --enable-shmop={{shared}} \
        --enable-simplexml={{shared}} \
        --with-snmp={{shared}} \
        --enable-soap={{shared}} \
        --enable-sockets={{shared}} \
        --with-sodium={{shared}} \
            --with-password-argon2 \
        --enable-sysvmsg={{shared}} \
        --enable-sysvsem={{shared}} \
        --enable-sysvshm={{shared}} \
        --with-tidy={{shared}} \
        --enable-tokenizer={{shared}} \
        --enable-xml={{shared}} \
            --with-libxml \
        --enable-xmlreader={{shared}} \
        --enable-xmlwriter={{shared}} \
        --with-xsl={{shared}} \
        --enable-zend-test={{shared}} \
        --with-zip={{shared}} \
        ;

_sapi_apache:
    @echo --with-apxs2 --disable-zts

_sapi_cgi:
   @echo --enable-cgi --disable-zts

_sapi_cli:
   @echo --enable-cli --enable-zts

_sapi_embed:
    @echo --enable-embed=shared --enable-zts

_sapi_fpm:
    @echo --enable-fpm --disable-zts

_sapi_phpdbg:
    @echo --enable-phpdbg --enable-phpdbg-readline

# to-do list
# * various *dbm packages (except gdbm, which is GPL)
# * support pdo_dblib
# * fix odbc test errors if easy, otherwise drop odbc entirely.
# * mysqli and mysqlnd both fail to load when built as shared.  fix this.
# * fuzzer sapi
# * gcov, valgrind support
# * investigate --with-external-pcre

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

make:
    make -j{{nproc}}

test:
    -TEST_PHP_ARGS='-q -j{{nproc}}' make test

install:
    rm -rf /opt/punk/*
    make install
    find /opt/punk/lib/php/extensions/* -type f

clean:
    rm -rf autom4te.cache .libs modules configure actmp.* config.* Makefile Makefile.* libtool
    rm -f {{platform_dir}}/config.cache
    git status --porcelain --ignored | egrep '^!! (ext|main|sapi|TSRM|Zend|scripts|tests)/' | cut -c3- | xargs rm -rf
