#!/bin/sh -ex
#make arrangements for ignoring pxwayland tests for osx and linux
currdir=`pwd`
cd $TRAVIS_BUILD_DIR/tests/pxScene2d/testRunner
cp tests.json tests.json_orig

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    sed -i -n '/pxWayland/d' tests.json
else
    sed -i '/pxWayland/d' tests.json
fi

cd $currdir

if [ "$TRAVIS_EVENT_TYPE" = "cron" ]; then
    export linenumber=`awk '/CFBundleShortVersionString/{ print NR; exit }' $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist`
    export PX_VERSION=`sed -n "\`echo $((linenumber+1))\`p" $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist|awk -F '<string>' '{print $2}'|awk -F'</string>' '{print $1}'`
fi

exit 0
