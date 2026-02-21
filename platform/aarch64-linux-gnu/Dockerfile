FROM debian:forky-slim AS base

ENV PLATFORM=aarch64-linux-gnu

RUN perl -pi -e 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    adduser \
    autoconf \
    bison \
    ccache \
    clang \
    clang-format \
    clang-tidy \
    just \
    meson \
    make \
    php-cli \
    pkg-config \
    re2c

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    libargon2-dev \
    libavif-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libfreetype-dev \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsodium-dev \
    libsqlite3-dev \
    libssl-dev \
    libwebp-dev \
    libxpm-dev \
    libxslt-dev \
    libz-dev \
    libzip-dev

# This is convenient for debian, but its leaf dependencies should be moved to the list above for easier porting
# RUN DEBIAN_FRONTEND=noninteractive apt install -y php-all-dev

RUN adduser --uid 10000 --disabled-password punk

WORKDIR /punk

#################################################################
FROM base AS builder

USER punk

ENV NO_INTERACTION=1

#################################################################
FROM base AS dev

RUN DEBIAN_FRONTEND=noninteractive apt install -y sudo \
    && adduser punk sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER punk

