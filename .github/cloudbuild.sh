#!/bin/bash

set -x

sudo chown -R travis:travis .
sudo chown travis:travis $HOME

#bundle exec .github/travis-expand.rb
#
#which travis
#travis --help
#travis compile --store-repo mithro/litex-conda > ci.sh
#chmod a+x ci.sh
#./ci.sh
#travis login --help
#travis login --pro --auto --no-manual

#travis compile --token 47SOJ3tnDZrlQIstbVHjlg --debug-http --debug 1 > /tmp/ci.1.sh
#travis compile --token 47SOJ3tnDZrlQIstbVHjlg --debug-http --debug 1.1 > /tmp/ci.1.1.sh
