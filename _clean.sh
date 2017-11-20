#!/bin/sh
rm -rf build build-*
rm -f examples/pxScene2d/src/*.{a,so}
rm -f examples/pxScene2d/src/pxscene
(cd remote; make clean)