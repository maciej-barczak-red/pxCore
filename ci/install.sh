#!/bin/sh -e

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
      echo "Ignoring install stage for $TRAVIS_EVENT_TYPE event";
      exit 0
fi

mkdir -p $TRAVIS_BUILD_DIR/logs
touch $TRAVIS_BUILD_DIR/logs/build_logs
BUILDLOGS=$TRAVIS_BUILD_DIR/logs/build_logs

if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
    mkdir -p $TRAVIS_BUILD_DIR/logs/codecoverage
    touch $TRAVIS_BUILD_DIR/logs/exec_logs
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    mkdir -p $TRAVIS_BUILD_DIR/artifacts
fi

echo "Building externals: "

if [ "$TRAVIS_PREFER_SYSTEM_LIBRARIES" = "ON" ]; then
    export PREFER_SYSTEM_LIBRARIES=ON
else
    export PREFER_SYSTEM_LIBRARIES=OFF
fi

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    export PATH=/usr/lib/ccache:$PATH
    export CC=/usr/lib/ccache/gcc
    export CXX=/usr/lib/ccache/g++
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    export PATH=/usr/local/opt/ccache/libexec:$PATH
    export CC=/usr/local/opt/ccache/libexec/cc
    export CXX=/usr/local/opt/ccache/libexec/c++
fi

export CCACHE_DIR=$HOME/Library/Caches/ccache
ccache -M 512M
ccache -s
ccache -z
(cd $TRAVIS_BUILD_DIR/examples/pxScene2d/external; /bin/sh -x ./build.sh 2>&1 > build.log || (echo "dumping build log:"; cat build.log; exit 1))
ccache -s
