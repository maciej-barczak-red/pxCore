#!/bin/sh -ex

if [ "$TRAVIS_CREATE_CACHE_ONLY" = "true" ]; then
    echo "Ignoring script stage for cache creation event";
    exit 0
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    echo "Ignoring script stage for $TRAVIS_EVENT_TYPE event";
    exit 0
fi

retval=0
ulimit -c unlimited
export DUMP_STACK_ON_EXCEPTION=1
cd $TRAVIS_BUILD_DIR/ci

if [ "$TRAVIS_PREFER_SYSTEM_LIBRARIES" = "ON" ]; then
    export PREFER_SYSTEM_LIBRARIES=ON
else
    export PREFER_SYSTEM_LIBRARIES=OFF
fi

if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
    /bin/sh -x "./build_$TRAVIS_OS_NAME.sh"

    if [ "$TRAVIS_OS_NAME" = "linux" ]; then
        export DISPLAY=:99.0
        /bin/sh -e /etc/init.d/xvfb start
        sleep 3
    fi

    /bin/sh -x "./unittests_$TRAVIS_OS_NAME.sh"
    /bin/sh -x "./execute_$TRAVIS_OS_NAME.sh"
    /bin/sh -x "./code_coverage_$TRAVIS_OS_NAME.sh"
else
    /bin/sh -x "./build_$TRAVIS_OS_NAME.sh"
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    cp $TRAVIS_BUILD_DIR/examples/pxScene2d/src/deploy/mac/*.dmg $TRAVIS_BUILD_DIR/artifacts/.
    cp $TRAVIS_BUILD_DIR/examples/pxScene2d/src/deploy/mac/software_update.plist $TRAVIS_BUILD_DIR/artifacts/.
fi

if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
    codecov --build "$TRAVIS_OS_NAME-$TRAVIS_COMMIT-$TRAVIS_BUILD_NUMBER" -X gcov -f $TRAVIS_BUILD_DIR/tracefile
    genhtml -o $TRAVIS_BUILD_DIR/logs/codecoverage $TRAVIS_BUILD_DIR/tracefile
fi

exit 0
