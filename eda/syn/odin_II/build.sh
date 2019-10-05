#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

cd ODIN_II
make build -j$CPU_COUNT
install -D odin_II $PREFIX/bin/odin_II
