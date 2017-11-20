#!/bin/bash
mkdir -p build-wayland-egl
pushd build-wayland-egl
#export CC=clang
#export CXX=clang++

cmake \
  -DPKG_CONFIG_DISABLE_NODE=OFF \
  -DPKG_CONFIG_DISABLE_NODE8=ON \
  -DSUPPORT_NODE=ON \
  -DSUPPORT_DUKTAPE=ON \
  -DPXCORE_WAYLAND_DISPLAY_READ_EVENTS=ON \
  -DPXSCENE_DIRTY_RECTANGLES=ON \
  -DDISABLE_DEBUG_MODE=OFF \
  -DBUILD_PX_TESTS=OFF \
  -DPREFER_SYSTEM_LIBRARIES=ON \
  -DBUILD_RTREMOTE_LIBS=OFF \
  -DPXCORE_WAYLAND_EGL=ON \
  -DBUILD_PXSCENE_WAYLAND_EGL=ON \
  -DPXCORE_ESSOS=OFF \
  -DBUILD_PXSCENE_ESSOS=OFF \
  -DBUILD_WITH_GL=ON \
  -DBUILD_WITH_WAYLAND=ON \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DBUILD_WITH_SERVICE_MANAGER=OFF \
  -DBUILD_PXSCENE_SHARED_LIB=OFF \
  -DBUILD_PXSCENE_APP=ON \
  -DCMAKE_CXX_FLAGS="-fsanitize=thread -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Werror -Woverloaded-virtual -Wno-deprecated-declarations -Wno-sign-compare -Wno-unused-parameter -Wno-deprecated-declarations -Werror=address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DUSE_STD_THREADS -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
#  -DCMAKE_CXX_FLAGS="-fno-rtti -fsanitize=undefined -fsanitize=shift -fsanitize=shift-exponent -fsanitize=shift-base -fsanitize=integer-divide-by-zero -fsanitize=unreachable -fsanitize=vla-bound -fsanitize=null -fsanitize=return -fsanitize=signed-integer-overflow -fsanitize=bounds -fsanitize=bounds-strict -fsanitize=alignment -fsanitize=object-size -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fsanitize=nonnull-attribute -fsanitize=returns-nonnull-attribute -fsanitize=bool -fsanitize=enum -fsanitize=vptr -fsanitize=signed-integer-overflow -fsanitize-address-use-after-scope -fsanitize-recover=address -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Werror -Wno-deprecated-declarations -Wno-sign-compare -Wno-unused-parameter -Wno-deprecated-declarations -Wformat=2 -Wno-format-y2k -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DUSE_STD_THREADS -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=undefined -fsanitize=shift -fsanitize=shift-exponent -fsanitize=shift-base -fsanitize=integer-divide-by-zero -fsanitize=unreachable -fsanitize=vla-bound -fsanitize=null -fsanitize=return -fsanitize=signed-integer-overflow -fsanitize=bounds -fsanitize=bounds-strict -fsanitize=alignment -fsanitize=object-size -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fsanitize=nonnull-attribute -fsanitize=returns-nonnull-attribute -fsanitize=bool -fsanitize=enum -fsanitize=vptr -fsanitize=signed-integer-overflow -fsanitize-address-use-after-scope -fsanitize-recover=address -fstack-protector-all -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Werror -Wno-deprecated-declarations -Wno-sign-compare -Wno-unused-parameter -Wno-deprecated-declarations -Werror=address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DUSE_STD_THREADS -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
#  -DCMAKE_CXX_FLAGS="-fsanitize=address -fsanitize-address-use-after-scope -fsanitize-recover=address -fstack-protector-all -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Werror -Wno-deprecated-declarations -Wno-sign-compare -Wno-unused-parameter -Wno-deprecated-declarations -Werror=address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DUSE_STD_THREADS -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
#  -DCMAKE_CXX_FLAGS="-fsanitize=thread -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Werror -Wno-deprecated-declarations -Wno-sign-compare -Wno-unused-parameter -Wno-deprecated-declarations -Werror=address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DUSE_STD_THREADS -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
#  -DCMAKE_CXX_FLAGS="-fsanitize=thread -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Wno-unused-parameter -Wno-maybe-uninitialized -Wno-deprecated-declarations -Wno-address -Wno-reorder -Wno-unused-variable -Wno-sign-compare -Wno-missing-field-initializers -Wno-delete-non-virtual-dtor -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-maybe-uninitialized -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=thread -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wall -Wextra -Wno-unused-parameter -Wno-maybe-uninitialized -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=address -fPIE -mmpx -fno-omit-frame-pointer -fno-delete-null-pointer-checks -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
# -DCMAKE_CXX_FLAGS="-fsanitize=memory -fsanitize-memory-track-origins -fPIE -fno-omit-frame-pointer -Wno-deprecated-declarations -Wno-address -DMESA_EGL_NO_X11_HEADERS -O0 -g3 -DPXSCENE_DISABLE_WST_DECODER -UENABLE_EGL_GENERIC" ..
time make -j$(nproc) VERBOSE=1 && echo "ok"
popd

# TSAN_OPTIONS=second_deadlock_stack=1
# TSAN_OPTIONS=second_deadlock_stack=1 ddd --args ./pxscene  https://raw.githubusercontent.com/pxscene/pxscene/gh-pages/examples/px-reference/gallery/fishtank/fishtank
