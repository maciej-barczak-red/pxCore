#!/bin/bash -ex

CWD=$PWD

DIRECTORY=$(cd `dirname $0` && pwd)

pushd $DIRECTORY
    quilt push -aq || test $? = 2
    mkdir -p build

    pushd build
        cmake -DCMAKE_VERBOSE_MAKEFILE=ON ..
        make -j$(getconf _NPROCESSORS_ONLN)
    popd
popd