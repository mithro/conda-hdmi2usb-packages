#!/bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

unset DEBUG_CFLAGS
unset DEBUG_CXXFLAGS
env
export M4=${PREFIX}/bin/m4
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} ..
grep -i flags CMakeCache.txt
make -j$CPU_COUNT
make test
make install

mkdir -p ${PREFIX}/lib
mv ${PREFIX}/bin/*.a ${PREFIX}/lib/
