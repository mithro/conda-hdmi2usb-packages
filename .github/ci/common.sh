# Some colors, use it like following;
# echo -e "Hello ${YELLOW}yellow${NC}"
GRAY=' \033[0;30m'
RED=' \033[0;31m'
GREEN=' \033[0;32m'
YELLOW=' \033[0;33m'
PURPLE=' \033[0;35m'
NC='\033[0m' # No Color

SPACER="echo -e ${GRAY} - ${NC}"

if [ -z "$PACKAGE" ]; then
	echo "Missing \$PACKAGE environment value."
	exit 1
fi

if ! declare -F travis_nanoseconds &>/dev/null; then
function travis_nanoseconds() {
	return 0;
}
fi
export -f travis_nanoseconds
if ! declare -F travis_fold &>/dev/null; then
function travis_fold() {
	return 0;
}
fi
export -f travis_fold
if ! declare -F travis_time_start &>/dev/null; then
function travis_time_start() {
	return 0;
}
fi
export -f travis_time_start
if ! declare -F travis_time_finish &>/dev/null; then
function travis_time_finish() {
	return 0;
}
fi
export -f travis_time_finish
if ! declare -F travis_wait &>/dev/null; then
function travis_wait() {
	return 0;
}
fi
export -f travis_wait
if ! declare -F travis_jigger &>/dev/null; then
function travis_jigger() {
	return 0;
}
fi
export -f travis_jigger
if [ -z "$DATE_STR" ]; then
	export DATE_TS="$(git log --format=%ct -n1)"
	export DATE_NUM="$(date --date=@${DATE_TS} -u +%Y%m%d%H%M%S)"
	export DATE_STR="$(date --date=@${DATE_TS} -u +%Y%m%d_%H%M%S)"
	echo "Setting date number to $DATE_NUM"
	echo "Setting date string to $DATE_STR"
fi

function start_section() {
	travis_fold start "$1"
	travis_time_start
	echo -e "${PURPLE}${PACKAGE}${NC}: - $2${NC}"
	echo -e "${GRAY}-------------------------------------------------------------------${NC}"
}

function end_section() {
	echo -e "${GRAY}-------------------------------------------------------------------${NC}"
	travis_time_finish
	travis_fold end "$1"
}

# Disable this warning;
# xxxx/conda_build/environ.py:377: UserWarning: The environment variable
#     'TRAVIS' is being passed through with value 0.  If you are splitting
#     build and test phases with --no-test, please ensure that this value is
#     also set similarly at test time.
export PYTHONWARNINGS=ignore::UserWarning:conda_build.environ

export CONDA_PATH="$HOME/conda"
export PATH="$CONDA_PATH/bin:$PATH"

export GIT_SSL_NO_VERIFY=1
export GITREV="$(git describe --long 2>/dev/null || echo "unknown")"
export CONDA_BUILD_ARGS=$PACKAGE
export CONDA_OUT="$(conda render --output $CONDA_BUILD_ARGS 2> /dev/null | grep conda-bld | grep tar.bz2 | tail -n 1 | sed -e's/-[0-9]\+\.tar/*.tar/' -e's/-git//')"

echo "          GITREV: $GITREV"
echo "      CONDA_PATH: $CONDA_PATH"
echo "CONDA_BUILD_ARGS: $CONDA_BUILD_ARGS"
echo "       CONDA_OUT: $CONDA_OUT"
