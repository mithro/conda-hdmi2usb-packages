#!/bin/bash

set -e

PACKAGE=${1:-PACKAGE}

TAG_EXTRACT='[0-9]+\.[0-9]+(\.[0-9])?$'
TAG_PATTERN='^v[0-9]+\.[0-9]+(\.[0-9])?$'

CONDA_GIT_URL=$(cat $PACKAGE/meta.yaml | grep "git_url" | awk '{print $2}')
CONDA_GIT_DIR=$CONDA_PATH/conda-bld/git_cache/$(echo "$CONDA_GIT_URL" | grep -o '://.*' | cut -f3- -d/)
if [ ! -d $CONDA_GIT_DIR ]; then
	git clone --bare "$CONDA_GIT_URL" $CONDA_GIT_DIR
fi
(
	export GIT_DIR=$CONDA_GIT_DIR

	CURRENT_HEAD=$(git rev-parse HEAD)
	LAST_HEAD=$(cat $GIT_DIR/TAG_FILTER 2> /dev/null || true)
	if [ g"$LAST_HEAD" != g"$CURRENT_HEAD" -o 1 -eq 1 ]; then
		# Disable automatic fetching of tags
		git config remote.origin.tagOpt --no-tags

		# Remove all tags
		for TAG in $(git tag --list); do
			git tag -d $TAG > /dev/null
		done

		# Manually fetch the tags
		echo "Fetching tags.."
		git fetch --tags
		echo

		echo "Initial set of tags:"
		git tag --list | sort --version-sort | grep --color=always -e "^" -e $TAG_PATTERN | sed -e's/^/ * /'
		echo

		# Rewrite non-standard tags
		for TAG in $(git tag --list | sort --version-sort | grep -P "$TAG_EXTRACT"); do
			TAG_VALUE=v$(echo $TAG | grep -o -P "$TAG_EXTRACT")
			if [ "$TAG" = "$TAG_VALUE" ]; then
				continue
			fi
			TAG_HASH=$(git rev-parse $TAG^{})
			if [ "$(git rev-parse $TAG_VALUE^{} 2> /dev/null)" != "$TAG_HASH" ]; then
				git tag -d $TAG_VALUE 2> /dev/null || true
				git tag -m"From tag $TAG" -a $TAG_VALUE $TAG_HASH
			fi

			echo "Extract? $TAG -> $TAG_VALUE ($TAG_HASH)"
		done
		echo

		# Remove all the non-version tags
		for TAG in $(git tag --list | sort --version-sort | grep -P -v "$TAG_PATTERN"); do
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

		# List the remaining tags
		echo "Remaining tags"
		git tag --list | sort --version-sort | sed -e's/^/ * /'
		echo
	fi
	echo "Git describe output: '$(git describe --tags)'"
)
