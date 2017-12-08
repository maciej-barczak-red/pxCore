// pxCore CopyRight 2005-2006 John Robinson
// Portable Framebuffer and Windowing Library
// pxEventLoopNative.cpp

#include "../pxEventLoop.h"

#include "../pxOffscreen.h"
#include "pxWindowNative.h"


void pxEventLoop::runOnce()
{
#ifndef ENABLE_EGL_GENERIC
  pxWindowNative::runEventLoopOnce();
#endif
}

void pxEventLoop::run()
{
    // For now we delegate off to the x11 pxWindowNative class
#ifndef ENABLE_EGL_GENERIC
    pxWindowNative::runEventLoop();
#endif //!ENABLE_DFB_GENERIC
}

void pxEventLoop::exit()
{
    // For now we delegate off to the x11 pxWindowNative class
#ifndef ENABLE_EGL_GENERIC
    pxWindowNative::exitEventLoop();
#endif //!ENABLE_DFB_GENERIC
}


///////////////////////////////////////////
// Entry Point 
#ifndef ENABLE_EGL_GENERIC
int main(int argc, char** argv)
{
  return pxMain(argc, argv);
}
#endif
