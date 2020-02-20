#!/bin/bash

set -e

CONDA_PATH=${1:-~/conda}

echo "Downloading Conda installer."
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh

if [ ! -d $CONDA_PATH ]; then
	echo "Installing conda"
        ./Miniconda3-latest-Linux-x86_64.sh -p $CONDA_PATH -b -f
fi
export PATH=$CONDA_PATH/bin:$PATH

function patch_conda() {
	# Patch conda to prevent a users ~/.condarc from infecting the build
	for F in $CONDA_PATH/lib/python3.*/site-packages/conda/common/configuration.py; do
		if grep -q "# FIXME: Patched conda" $F; then
			echo "Already patched $F"
		else
			echo "Patching $F"
			cat >> $F <<'EOF'

# FIXME: Patched conda
_load_file_configs = load_file_configs
def load_file_configs(search_path):
    return _load_file_configs([p for p in search_path if p.startswith('$CONDA_')])
EOF
		fi
	done
}

patch_conda

cat > $CONDA_PATH/condarc <<'EOF'
# Useful for automation
show_channel_urls: True

# Prevent conda from automagically updating things
auto_update_conda: False
update_dependencies: False
# Don't complain
notify_outdated_conda: false
# Add channels
channel_priority: strict
channels:
EOF
CONDA_CHANNEL=$(echo $TRAVIS_REPO_SLUG | sed -e's@/.*$@@')
if [ x$CONDA_CHANNEL != x ];then
cat >> $CONDA_PATH/condarc <<EOF
 - $CONDA_CHANNEL
EOF
fi
cat >> $CONDA_PATH/condarc <<'EOF'
 - symbiflow
 - defaults
EOF

# Install required build tools
conda install -y conda-build anaconda-client jinja2 conda-verify ripgrep pexpect

conda info | grep --color=always -e "^" -e "populated config files"
