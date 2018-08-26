#!/bin/bash

source $TRAVIS_BUILD_DIR/.travis/common.sh
set -e

# Getting the conda environment
start_section "environment.conda" "Setting up basic ${YELLOW}conda environment${NC}"

mkdir -p $BASE_PATH
./conda-get.sh $CONDA_PATH
hash -r
conda config --set always_yes yes --set changeps1 no
conda install pexpect
conda config --add channels timvideos
for CHANNEL in $CONDA_CHANNELS; do
	conda config --add channels $CHANNEL
done
conda config --add channels $(echo $TRAVIS_REPO_SLUG | sed -e's@/.*$@@')
conda clean -s --dry-run
conda build purge
conda clean -s --dry-run

./conda-meta-extra.sh

end_section "environment.conda"

$SPACER

# Output some useful info
start_section "info.conda.env" "Info on ${YELLOW}conda environment${NC}"
conda info
end_section "info.conda.env"

start_section "info.conda.config" "Info on ${YELLOW}conda config${NC}"
conda config --show
end_section "info.conda.config"

start_section "info.conda.package" "Info on ${YELLOW}conda package${NC}"
conda render $CONDA_BUILD_ARGS
end_section "info.conda.package"

start_section "info.autotools" "Info on ${YELLOW}autotools${NC}"
autoconf --version
automake --version
libtool --version
end_section "info.autotools"
