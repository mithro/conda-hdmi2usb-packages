#!/bin/bash

set -e
set +x

echo "------------------------"

echo $PWD
which yosys
which netlistsvg

echo "------------------------"

NETLISTSVG=$(which netlistsvg)
NETLISTSVG_SKIN=$PREFIX/lib/node_modules/netlistsvg/lib/default.svg
NETLISTSVG_EXAMPLES=$PREFIX/lib/node_modules/netlistsvg/examples/*
cp -aR $NETLISTSVG_EXAMPLES .

sed -i -e's/\( %\.[^ ]*\)png/\1svg/g' Makefile

echo "------------------------"

make \
	NETLISTSVG=$NETLISTSVG \
	NETLISTSVG_SKIN=$NETLISTSVG_SKIN \
	build.all

echo "------------------------"

ls *.svg
