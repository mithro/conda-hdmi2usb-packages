#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

cargo build --release
install -D target/release/moore $PREFIX/bin/moore

$PREFIX/bin/moore --version
