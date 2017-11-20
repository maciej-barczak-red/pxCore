#!/bin/bash
#export CC=clang
#export CXX=clang++

mkdir -p build
pushd build
cmake \
  -DPKG_CONFIG_DISABLE_NODE=OFF \
  -DPKG_CONFIG_DISABLE_NODE8=OFF \
  -DPXSCENE_COMPILE_WARNINGS_AS_ERRORS=OFF \
  -DPXCORE_COMPILE_WARNINGS_AS_ERRORS=OFF \
  -DSUPPORT_NODE=ON \
  -DSUPPORT_DUKTAPE=ON \
  -DPXCORE_WAYLAND_DISPLAY_READ_EVENTS=OFF \
  -DDISABLE_DEBUG_MODE=OFF \
  -DBUILD_PX_TESTS=ON \
  -DBUILD_PXSCENE_RASTERIZER_PATH=ON \
  -DBUILD_RTREMOTE_LIBS=ON \
  -DBUILD_WITH_STATIC_NODE=OFF \
  -DPREFER_SYSTEM_LIBRARIES=ON \
  -DBUILD_PXSCENE_STATIC_LIB=ON \
  -DPXSCENE_TEST_HTTP_CACHE=OFF \
  -DBUILD_DEBUG_METRICS=ON \
  -DCMAKE_CXX_FLAGS="-fno-delete-null-pointer-checks -Wno-unused-parameter -Wno-sign-compare -Wno-deprecated-declarations -Wformat=2 -Wno-format-y2k -Wall -Werror -Wextra -Woverloaded-virtual -Wno-strict-aliasing -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER" ..
#  -DCMAKE_CXX_FLAGS="-fno-delete-null-pointer-checks -Wall -Werror -Wextra -Werror=unused-but-set-variable -Wno-unused-parameter -Wno-deprecated-declarations -Wno-sign-compare -Wno-unused-parameter -Wno-deprecated-declarations -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -std=gnu++14" ..
time make -j$(nproc) VERBOSE=1 && echo "ok"
popd
