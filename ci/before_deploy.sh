#!/bin/sh

rv=0

if [ -f $TRAVIS_BUILD_DIR/.after_script_rv ]; then
    rv=$(cat $TRAVIS_BUILD_DIR/.after_script_rv)
fi

exit ${rv}
