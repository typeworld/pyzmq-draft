# libzmq build taken from here:
# https://github.com/zeromq/libzmq/blob/master/Dockerfile

# Use the official lightweight Python image.
# https://hub.docker.com/_/python
# FROM python:3.8-slim
FROM python:3.8-slim
LABEL maintainer="tech@type.world"
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /
# install git & clone libzmq
RUN apt-get update -qq && apt-get install -y --no-install-recommends git \
    && git clone https://github.com/zeromq/libzmq.git \
    && cd libzmq \ 

    # build libzmq
    && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    libkrb5-dev \
    libsodium-dev \
    libtool \
    pkg-config \

    # build libzmq
    && ./autogen.sh \
    && mkdir /build-libzmq \
    && ./configure --prefix=/build-libzmq --enable-drafts --with-libsodium --with-libgssapi_krb5 \
    && make \
    && make check \
    && make install \
    && make clean \

    # install pyzmq
    && pip install --pre pyzmq --install-option=--enable-drafts --install-option=--zmq=/build-libzmq \

    # uninstall packages
    && apt-get purge -qq \
    git \
    autoconf \
    automake \
    build-essential \
    # libkrb5-dev \
    # libsodium-dev \
    libtool \
    pkg-config \

    && apt-get clean \
    && apt-get autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /libzmq
