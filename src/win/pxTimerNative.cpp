// pxCore CopyRight 2007-2018 John Robinson
// Portable Framebuffer and Windowing Library
// pxTimerNative.cpp

#if __cplusplus < 201103L

#include <windows.h>
#include <stdint.h>
#include <stdlib.h>

static bool gFreqInitialized = false;
static LARGE_INTEGER gFreq;

double pxSeconds()
{
    if (!gFreqInitialized)
    {
        ::QueryPerformanceFrequency(&gFreq);
        gFreqInitialized = true;
    }

    LARGE_INTEGER c;
    ::QueryPerformanceCounter(&c);

    return (c.QuadPart / (double)gFreq.QuadPart);
}

double pxMilliseconds()
{
    if (!gFreqInitialized)
    {
        ::QueryPerformanceFrequency(&gFreq);
        gFreqInitialized = true;
    }

    LARGE_INTEGER c;
    ::QueryPerformanceCounter(&c);

    return (c.QuadPart * 1000) / (double)gFreq.QuadPart;
}

double pxMicroseconds()
{
    if (!gFreqInitialized)
    {
        ::QueryPerformanceFrequency(&gFreq);
        gFreqInitialized = true;
    }

    LARGE_INTEGER c;
    ::QueryPerformanceCounter(&c);

    return (c.QuadPart * 1000000) / (double)gFreq.QuadPart;
}

void pxSleepUS(uint64_t usToSleep)
{
    abort(); // simply not implemented
}

void pxSleepMS(uint32_t msToSleep)
{
    Sleep(msToSleep);
}

#endif // __cplusplus < 201103L
