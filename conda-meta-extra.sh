#!/bin/bash

PACKAGE=${1:-PACKAGE}
if [ x$PACKAGE = x"" ]; then
	echo "\$PACKAGE not set!"
	exit 1
fi

rm -f $PACKAGE/recipe_append.yaml
cat > $PACKAGE/recipe_append.yaml <<EOF
extra:
  maintainers:
    - Tim 'mithro' Ansell <mithro@mithis.com>
    - SymbiFlow Project - https://symbiflow.github.io
  travis:
    job_id:  $TRAVIS_JOB_ID
    job_num: $TRAVIS_JOB_NUMBER
    type:    $TRAVIS_EVENT_TYPE
  recipe:
    repo:     'https://github.com/$TRAVIS_REPO_SLUG'
    branch:   $TRAVIS_BRANCH
    commit:   $TRAVIS_COMMIT
    describe: $GITREV
    date:     $DATESTR
EOF
if [ -e $PACKAGE/condarc ]; then
	cat $PACKAGE/condarc | sed -e's/^/  /' >> $PACKAGE/recipe_append.yaml
fi
