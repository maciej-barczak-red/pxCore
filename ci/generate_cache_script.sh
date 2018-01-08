#!/bin/sh -ex

mkdir -p $TRAVIS_BUILD_DIR/logs
touch $TRAVIS_BUILD_DIR/logs/build_logs
BUILDLOGS=$TRAVIS_BUILD_DIR/logs/build_logs

cd $TRAVIS_BUILD_DIR/examples/pxScene2d/external
./build.sh
