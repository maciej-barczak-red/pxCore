#!/bin/sh
#export CC=clang
#export CXX=clang++

mkdir -p build
pushd build
cmake \
  -DSUPPORT_NODE=ON \
  -DSUPPORT_DUKTAPE=ON \
  -DPXCORE_WAYLAND_DISPLAY_READ_EVENTS=OFF \
  -DDISABLE_DEBUG_MODE=OFF \
  -DBUILD_PX_TESTS=ON \
  -DBUILD_WITH_STATIC_NODE=OFF \
  -DPREFER_SYSTEM_LIBRARIES=ON \
  -DBUILD_PXSCENE_STATIC_LIB=ON \
  -DPXSCENE_TEST_HTTP_CACHE=OFF \
  -DBUILD_DEBUG_METRICS=ON \
  -DCMAKE_CXX_FLAGS="-fno-delete-null-pointer-checks -fno-delete-null-pointer-checks -Wall -Wextra -Werror=unused-but-set-variable -Wno-unused-parameter -Wno-deprecated-declarations -Wno-sign-compare -Werror=missing-field-initializers -Wno-unused-parameter -Wno-deprecated-declarations -Werror=address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER" ..
time make -j$(nproc) VERBOSE=1 && echo "ok"
popd
