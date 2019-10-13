#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

which npm
ls $PWD
npm install -g netlistsvg

ls $PREFIX/lib/node_modules/netlistsvg
ls $PREFIX/lib/node_modules/netlistsvg/doc
ls $PREFIX/lib/node_modules/netlistsvg/lib/default.svg
