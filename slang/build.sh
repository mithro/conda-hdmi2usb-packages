#! /bin/bash

set -e
set -x

sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update
sudo apt install -y gcc-8 g++-8

export CC=gcc-8
export CXX=g++-8

mkdir build && cd build

cmake .. -DSLANG_INCLUDE_TESTS=OFF -DCMAKE_BUILD_TYPE=Release

make

install -D bin/driver $PREFIX/bin/slang-driver
install -D bin/rewriter $PREFIX/bin/slang-rewriter
