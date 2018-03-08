#!/bin/bash -ex

CWD=$PWD

DIRECTORY=$(cd `dirname $0` && pwd)

pushd $DIRECTORY
    quilt push -aq || test $? = 2
    ./configure
    make -j$(getconf _NPROCESSORS_ONLN)
popd