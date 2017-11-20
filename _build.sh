#!/bin/sh
mkdir -p build
pushd build
cmake \
  -DDISABLE_DEBUG_MODE=ON \
  -DBUILD_PX_TESTS=ON \
  -DBUILD_WITH_STATIC_NODE=OFF \
  -DPREFER_SYSTEM_LIBRARIES=ON \
  -DBUILD_PXSCENE_SHARED_LIB=ON \
  -DCMAKE_CXX_FLAGS="-fno-delete-null-pointer-checks -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER" ..
time make -j$(nproc) VERBOSE=1
popd
