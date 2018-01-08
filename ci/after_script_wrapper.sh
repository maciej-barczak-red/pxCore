#!/bin/sh

/bin/sh -xe $TRAVIS_BUILD_DIR/ci/after_script.sh
rv=$?
echo $rv >$TRAVIS_BUILD_DIR/.after_script_rv

exit 0
