#!/bin/bash

export CONDA_PATH=${CONDA_PATH:-~/conda}
if [ ! -d $CONDA_PATH ];then
	echo "Conda not found at $CONDA_PATH"
	exit 1
fi
if [ ! -f $CONDA_PATH/bin/activate ];then
	echo "conda's bin/activate not found in $CONDA_PATH"
	exit 1
fi

# Disable this warning;
# xxxx/conda_build/environ.py:377: UserWarning: The environment variable
#     'TRAVIS' is being passed through with value 0.  If you are splitting
#     build and test phases with --no-test, please ensure that this value is
#     also set similarly at test time.
export  PYTHONWARNINGS=ignore::UserWarning:conda_build.environ

if [ -z "$DATE_STR" ]; then
	export DATE_NUM="$(date -u +%y%m%d%H%M)"
	export DATE_STR="$(date -u +%Y%m%d_%H%M%S)"
	echo "Setting date number to $DATE_NUM"
	echo "Setting date string to $DATE_STR"
fi
if [ -z "$GITREV" ]; then
	export GITREV="$(git describe --long)"
	echo "Setting git revision $GITREV"
fi

export TRAVIS=0
export CI=0

export TRAVIS_EVENT_TYPE="local"
echo "TRAVIS_EVENT_TYPE='${TRAVIS_EVENT_TYPE}'"

export TRAVIS_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "TRAVIS_BRANCH='${TRAVIS_BRANCH}'"

export TRAVIS_COMMIT="$(git rev-parse HEAD)"
echo "TRAVIS_COMMIT='${TRAVIS_COMMIT}'"

export TRAVIS_REPO_SLUG="$(git rev-parse --abbrev-ref --symbolic-full-name @{u})"
echo "TRAVIS_REPO_SLUG='${TRAVIS_REPO_SLUG}'"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$CONDA_PATH/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PATH/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_PATH/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

./conda-meta-extra.sh
conda $@
