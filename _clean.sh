#!/bin/sh
rm -rf build build-*
rm -f examples/pxScene2d/src/*.{a,so}
(cd remote; make clean)