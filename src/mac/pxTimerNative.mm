// pxCore CopyRight 2005-2018 John Robinson
// Portable Framebuffer and Windowing Library
// pxTimerNative.cpp

#if __cplusplus < 201103L

#include "pxTimer.h"

#if 0
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#endif 

#include <stdlib.h>
#include <unistd.h>

//#define USE_CGT

#ifndef USE_CGT
#include <sys/time.h>
#else
#include <time.h>
#endif

uint64_t pxSeconds()
{
#ifndef USE_CGT
    timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec;
#else
    timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec;
#endif
}

uint64_t pxMilliseconds()
{
#ifndef USE_CGT
    timeval tv;
    gettimeofday(&tv, NULL);
    return (tv.tv_sec * 1000UL) + (tv.tv_usec/1000UL);
#else
    timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (ts.tv_sec * 1000UL) + (ts.tv_nsec/1000000UL));
#endif
}

uint64_t pxMicroseconds()
{
#ifndef USE_CGT
    timeval tv;
    gettimeofday(&tv, NULL);
    return (tv.tv_sec * 1000000UL) + tv.tv_usec;
#else
    timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (ts.tv_sec * 1000000UL) + (ts.tv_nsec/1000UL));
#endif
}

void pxSleepUS(uint64_t usToSleep)
{
  usleep(usToSleep);
}

void pxSleepMS(uint32_t msToSleep)
{
  pxSleepUS(msToSleep * 1000UL);
}

#endif // __cplusplus < 201103L
