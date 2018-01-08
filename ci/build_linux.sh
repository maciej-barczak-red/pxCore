#!/bin/sh -ex

export CODE_COVERAGE=1
cd $TRAVIS_BUILD_DIR
mkdir -p temp

cd temp

cmake -DBUILD_PX_TESTS=ON -DBUILD_PXSCENE_STATIC_LIB=ON -DBUILD_DEBUG_METRICS=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ..
cmake --build . --clean-first -- -j$(getconf _NPROCESSORS_ONLN)

cd $TRAVIS_BUILD_DIR
