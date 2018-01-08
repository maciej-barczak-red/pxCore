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
/bin/sh -x "./build_$TRAVIS_OS_NAME.sh"
ccache -s

exit 0
