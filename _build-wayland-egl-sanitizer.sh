#!/bin/sh
mkdir -p build-wayland-egl
pushd build-wayland-egl
#export CC=clang
#export CXX=clang++

cmake \
  -DDISABLE_DEBUG_MODE=ON \
  -DBUILD_PX_TESTS=OFF \
  -DPREFER_SYSTEM_LIBRARIES=ON \
  -DBUILD_RTREMOTE_LIBS=ON \
  -DPXCORE_WAYLAND_EGL=ON \
  -DBUILD_PXSCENE_WAYLAND_EGL=ON \
  -DBUILD_WITH_GL=ON \
  -DBUILD_WITH_WAYLAND=ON \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DBUILD_WITH_SERVICE_MANAGER=OFF \
  -DBUILD_PXSCENE_SHARED_LIB=OFF \
  -DBUILD_PXSCENE_APP=ON \
  -DCMAKE_CXX_FLAGS="-fsanitize=thread -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=address -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=memory -fsanitize-memory-track-origins -fPIE -fno-omit-frame-pointer -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
time make -j$(nproc) VERBOSE=1 && echo "ok"
popd

# TSAN_OPTIONS=second_deadlock_stack=1
# TSAN_OPTIONS=second_deadlock_stack=1 ddd --args ./pxscene  https://raw.githubusercontent.com/pxscene/pxscene/gh-pages/examples/px-reference/gallery/fishtank/fishtank
