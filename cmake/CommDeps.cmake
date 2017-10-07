if (PREFER_SYSTEM_LIBRARIES)
  find_package(ZLIB REQUIRED)
endif(PREFER_SYSTEM_LIBRARIES)
if (NOT ZLIB_FOUND)
  message(STATUS "Using built-in zlib library")
  set(ZLIB_INCLUDE_DIRS "${EXTDIR}/zlib")
  set(ZLIB_LIBRARY_DIRS "${EXTDIR}/zlib")
  set(ZLIB_LIBRARIES "z")
endif(NOT ZLIB_FOUND)

if (PREFER_SYSTEM_LIBRARIES)
  find_package(CURL REQUIRED)
endif(PREFER_SYSTEM_LIBRARIES)
if (NOT CURL_FOUND)
  message(STATUS "Using built-in curl library")
  set(CURL_INCLUDE_DIRS "${EXTDIR}/curl/include")
  set(CURL_LIBRARY_DIRS "${EXTDIR}/curl/lib/.libs")
  set(CURL_LIBRARIES "curl")
endif(NOT CURL_FOUND)

if (PREFER_SYSTEM_LIBRARIES)
  find_package(JPEG REQUIRED)
endif(PREFER_SYSTEM_LIBRARIES)
if (NOT JPEG_FOUND)
  message(STATUS "Using built-in jpeg library")
  set(JPEG_INCLUDE_DIRS "${EXTDIR}/jpg")
  set(JPEG_LIBRARY_DIRS "${EXTDIR}/jpg/.libs")
  set(JPEG_LIBRARIES "jpeg")
endif(NOT JPEG_FOUND)

if (PREFER_SYSTEM_LIBRARIES)
  pkg_search_module(TURBO_JPEG libturbojpeg)
endif(PREFER_SYSTEM_LIBRARIES)
if (NOT TURBO_JPEG_FOUND)
  message(STATUS "Checking built-in libturbojpeg library")
  set(TURBO_JPEG_INCLUDE_DIRS "${EXTDIR}/libjpeg-turbo")
  set(TURBO_JPEG_LIBRARY_DIRS "${EXTDIR}/libjpeg-turbo/.libs")
  set(TURBO_JPEG_LIBRARIES "turbojpeg")
  find_file(TURBO_JPEG_SO_FILE libturbojpeg.so PATHS ${TURBO_JPEG_LIBRARY_DIRS} NO_DEFAULT_PATH)
endif(NOT TURBO_JPEG_FOUND)

if (TURBO_JPEG_FOUND OR TURBO_JPEG_SO_FILE)
  message(STATUS "Have ENABLE_LIBJPEG_TURBO")
  set(TURBO_DEFINITIONS "-DENABLE_LIBJPEG_TURBO")
endif(TURBO_JPEG_FOUND OR TURBO_JPEG_SO_FILE)

if (PREFER_SYSTEM_LIBRARIES)
  find_package(PNG REQUIRED)
endif (PREFER_SYSTEM_LIBRARIES)
if (NOT PNG_FOUND)
  message(STATUS "Using built-in libpng library")
  set(PNG_INCLUDE_DIRS "${EXTDIR}/png")
  set(PNG_LIBRARY_DIRS "${EXTDIR}/png/.libs")
  set(PNG_LIBRARIES "png16")
endif(NOT PNG_FOUND)

if (PREFER_SYSTEM_LIBRARIES)
  pkg_search_module(FREETYPE REQUIRED freetype2)
endif (PREFER_SYSTEM_LIBRARIES)
if (NOT FREETYPE_FOUND)
  message(STATUS "Using built-in freetype2 library")
  set(FREETYPE_INCLUDE_DIRS "${EXTDIR}/ft/include")
  set(FREETYPE_LIBRARY_DIRS "${EXTDIR}/ft/objs/.libs")
  set(FREETYPE_LIBRARIES "freetype")
endif(NOT FREETYPE_FOUND)

find_package(GLEW)
pkg_search_module(GL gl)
pkg_search_module(EGL egl)
pkg_search_module(GLESV2 glesv2)
pkg_search_module(CRYPTO libcrypto)
pkg_search_module(OPENSSL openssl)
pkg_search_module(FREEGLUT freeglut)
pkg_search_module(X11 x11)
pkg_search_module(UV libuv)

set(COMM_DEPS_DEFINITIONS ${COMM_DEPS_DEFINITIONS} ${TURBO_DEFINITIONS})

set(COMM_DEPS_INCLUDE_DIRS ${COMM_DEPS_INCLUDE_DIRS}
        ${ZLIB_INCLUDE_DIRS}
        ${CURL_INCLUDE_DIRS}
        ${JPEG_LIBRARY_DIRS}
  ${TURBO_JPEG_INCLUDE_DIRS}
         ${PNG_INCLUDE_DIRS}
    ${FREETYPE_INCLUDE_DIRS}
        ${GLEW_INCLUDE_DIRS}
          ${GL_INCLUDE_DIRS}
         ${EGL_INCLUDE_DIRS}
      ${GLESV2_INCLUDE_DIRS}
      ${CRYPTO_INCLUDE_DIRS}
     ${OPENSSL_INCLUDE_DIRS}
    ${FREEGLUT_INCLUDE_DIRS}
         ${X11_INCLUDE_DIRS}
          ${UV_INCLUDE_DIRS}
   )

set(COMM_DEPS_LIBRARY_DIRS ${COMM_DEPS_LIBRARY_DIRS}
        ${ZLIB_LIBRARY_DIRS}
        ${CURL_LIBRARY_DIRS}
        ${JPEG_LIBRARY_DIRS}
  ${TURBO_JPEG_LIBRARY_DIRS}
         ${PNG_LIBRARY_DIRS}
    ${FREETYPE_LIBRARY_DIRS}
        ${GLEW_LIBRARY_DIRS}
          ${GL_LIBRARY_DIRS}
         ${EGL_LIBRARY_DIRS}
      ${GLESV2_LIBRARY_DIRS}
      ${CRYPTO_LIBRARY_DIRS}
     ${OPENSSL_LIBRARY_DIRS}
    ${FREEGLUT_LIBRARY_DIRS}
         ${X11_LIBRARY_DIRS}
          ${UV_LIBRARY_DIRS}
   )

set(COMM_DEPS_LIBRARIES ${COMM_DEPS_LIBRARIES}
           ${ZLIB_LIBRARIES}
           ${CURL_LIBRARIES}
           ${JPEG_LIBRARIES}
     ${TURBO_JPEG_LIBRARIES}
            ${PNG_LIBRARIES}
       ${FREETYPE_LIBRARIES}
           ${GLEW_LIBRARIES}
             ${GL_LIBRARIES}
            ${EGL_LIBRARIES}
         ${GLESV2_LIBRARIES}
         ${CRYPTO_LIBRARIES}
        ${OPENSSL_LIBRARIES}
       ${FREEGLUT_LIBRARIES}
            ${X11_LIBRARIES}
             ${UV_LIBRARIES}
   )
