#!/bin/bash

set -x
set -e

CONDA_PATH=${1:-~/conda}

wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh
if [ ! -d $CONDA_PATH -o ! -z "$CI"  ]; then
        ./Miniconda3-latest-Linux-x86_64.sh -p $CONDA_PATH -b -f
fi
export PATH=$CONDA_PATH/bin:$PATH

# This appears to be required now because of a broken upstream package
# dependency in conda-forge.
conda install -y libiconv

conda update -y conda setuptools
if [ ! -z "$CONDA_BUILD_VERSION" ]; then
	conda install -y conda-build==$CONDA_BUILD_VERSION
	echo "conda-build==$CONDA_BUILD_VERSION" > $CONDA_PATH/conda-meta/pinned
else
	conda install -y conda-build
fi
conda install -y anaconda-client
conda install -y conda-verify
conda install -y jinja2
