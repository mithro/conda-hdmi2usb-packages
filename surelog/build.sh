#! /bin/bash

set -e
set -x

if [ x"$TRAVIS" = xtrue ]; then
  CPU_COUNT=2
fi

mkdir build && cd build

# TODO(hzeller): even though gperftools are installed, -ltcmalloc is not found.
LDFLAGS="-lrt" cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_VERBOSE_MAKEFILE=1 -DNO_TCMALLOC=ON

make -j$CPU_COUNT install


