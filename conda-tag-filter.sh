#!/bin/bash

set -e

PACKAGE=${1:-PACKAGE}

TAG_PATTERN='^v[0-9]+\.[0-9]+(\.[0-9])?$'

CONDA_GIT_URL=$(cat $PACKAGE/meta.yaml | grep "git_url" | awk '{print $2}')
CONDA_GIT_DIR=$CONDA_PATH/conda-bld/git_cache/$(echo "$CONDA_GIT_URL" | grep -o '://.*' | cut -f3- -d/)
echo "Conda git cache dir: '$CONDA_GIT_DIR'"
if [ ! -d $CONDA_GIT_DIR ]; then
	echo "URL='$CONDA_GIT_URL' DIR='$CONDA_GIT_DIR'"
	git clone --bare "$CONDA_GIT_URL" $CONDA_GIT_DIR
fi
(
	export GIT_DIR=$CONDA_GIT_DIR

	CURRENT_HEAD=$(git rev-parse HEAD)
	LAST_HEAD=$(cat $GIT_DIR/TAG_FILTER 2> /dev/null || true)
	if [ g"$LAST_HEAD" != g"$CURRENT_HEAD" ]; then
		# Disable automatic fetching of tags
		git config remote.origin.tagOpt --no-tags

		# Manually fetch the tags
		echo "Fetching tags.."
		git fetch --tags
		echo

		echo "Initial set of tags:"
		git tag --list | sort --version-sort | grep --color=always -e "^" -e $TAG_PATTERN | sed -e's/^/ * /'
		echo

		# Remove all the non-version tags
		for TAG in $(git tag --list | sort --version-sort | grep -P -v $TAG_PATTERN); do
			git tag -d $TAG
		done
		echo

		# Add a tag if it doesn't exist
		if [ $(git tag --list | wc -l) -eq 0 ]; then
			OLDEST_COMMIT=$(git log --reverse --pretty=%H | head -n1)
			echo "Adding v0.0 to $OLDEST_COMMIT (first commit in repository!)"
			git tag -a v0.0 $OLDEST_COMMIT -m"v0.0"
			echo
		fi
		git rev-parse HEAD > $GIT_DIR/TAG_FILTER
	fi

	# List the remaining tags
	echo "Remaining tags"
	git tag --list | sort --version-sort | sed -e's/^/ * /'
	echo

	echo "Git describe output: '$(git describe --tags)'"
)
