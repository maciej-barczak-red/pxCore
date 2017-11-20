#!/bin/sh
rm -rf build build-*
rm -f examples/pxScene2d/src/*.{a,so}
rm -f examples/pxScene2d/src/pxscene
rm -f tests/pxScene2d/pxscene2dtests
(cd remote; make clean)