FROM debian:jessie

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    build-essential gcc-multilib \
    m4 \
    ca-certificates \
    curl \
    autoconf \
    unzip \
    nasm \
    && rm -rf /var/lib/apt/lists/*

ENV BISON_VERSION 3.7.2
ENV FLEX_VERSION  2.6.4
ENV CMAKE_VERSION 3.18.2
ENV NINJA_VERSION 1.10.1

RUN curl -o /root/bison-$BISON_VERSION.tar.xz -fSL http://www.nic.funet.fi/pub/gnu/ftp.gnu.org/pub/gnu/bison/bison-$BISON_VERSION.tar.xz \
    && curl -o /root/bison-$BISON_VERSION.tar.xz.sig -fSL http://www.nic.funet.fi/pub/gnu/ftp.gnu.org/pub/gnu/bison/bison-$BISON_VERSION.tar.xz.sig \
    && gpg --keyserver keys.gnupg.net --recv-keys 78D5264E \
    && gpg --verify /root/bison-$BISON_VERSION.tar.xz.sig \
    && rm /root/bison-$BISON_VERSION.tar.xz.sig \
    && cd /root/ \
    && tar -xf bison-$BISON_VERSION.tar.xz \
    && rm bison-$BISON_VERSION.tar.xz \
    && cd bison-$BISON_VERSION \
    && ./configure --disable-dependency-tracking \
    && make \
    && make install

RUN curl -o /root/flex-$FLEX_VERSION.tar.gz -fSL https://github.com/westes/flex/releases/download/v$FLEX_VERSION/flex-$FLEX_VERSION.tar.gz \
    && cd /root/ \
    && tar -xf flex-$FLEX_VERSION.tar.gz \
    && rm flex-$FLEX_VERSION.tar.gz \
    && cd flex-$FLEX_VERSION \
    && ./configure \
    && make \
    && make install

RUN curl -o /root/cmake-$CMAKE_VERSION.tar.gz -fSL https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz \
    && cd /root/ \
    && tar -xf cmake-$CMAKE_VERSION.tar.gz \
    && mv cmake-$CMAKE_VERSION-Linux-x86_64 cmake \
    && rm cmake-$CMAKE_VERSION.tar.gz

RUN cd /root/ \
    && mkdir ninja \
    && cd ninja \
    && curl -o /root/ninja/ninja-linux.zip -fSL https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip \
    && unzip ninja-linux.zip \
    && rm ninja-linux.zip

ENV PATH="/root/cmake/bin:${PATH}"
ENV PATH="/root/ninja:${PATH}"

WORKDIR /tmp/project
