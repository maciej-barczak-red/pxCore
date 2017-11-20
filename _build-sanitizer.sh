#!/bin/sh
mkdir -p build
pushd build

mkdir -p build-native
(cd build-native; cmake ../../remote && make VERBOSE=1 rtRemoteConfigGen)

#export CC=clang
#export CXX=clang++

cmake \
  -DRTREMOTE_GENERATOR_EXPORT=build-native/rtRemoteConfigGen_export.cmake \
  -DPXSCENE_COMPILE_WARNINGS_AS_ERRORS=ON \
  -DPXCORE_COMPILE_WARNINGS_AS_ERRORS=ON \
  -DPXCORE_WAYLAND_DISPLAY_READ_EVENTS=OFF \
  -DDISABLE_DEBUG_MODE=ON \
  -DBUILD_PX_TESTS=ON \
  -DBUILD_WITH_STATIC_NODE=OFF \
  -DPREFER_SYSTEM_LIBRARIES=ON \
  -DBUILD_PXSCENE_SHARED_LIB=ON \
  -DBUILD_DEBUG_METRICS=ON \
  -DCMAKE_CXX_FLAGS="-fsanitize=address -fPIE -fno-omit-frame-pointer -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=thread -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Wno-unused-parameter -Wno-maybe-uninitialized -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
time make -j$(nproc) VERBOSE=1 && echo "ok"
popd
