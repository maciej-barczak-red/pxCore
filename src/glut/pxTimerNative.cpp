// pxCore CopyRight 2005-2018 John Robinson
// Portable Framebuffer and Windowing Library
// pxTimerNative.cpp

#if __cplusplus < 201103L

#include "../pxTimer.h"

#include <stdlib.h>
#include <errno.h>

#include "pxConfigNative.h"

#ifndef USE_CGT
#include <sys/time.h>
#else
#include <time.h>
#endif

double  pxSeconds()
{
#ifndef USE_CGT
    timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + ((double)tv.tv_usec/1000000);
#else
    timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ((double)ts.tv_nsec/1000000000);
#endif
}

double pxMilliseconds()
{
#ifndef USE_CGT
    timeval tv;
    gettimeofday(&tv, NULL);
    return ((double)(tv.tv_sec * 1000) + ((double)tv.tv_usec/1000));
#else
    timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ((double)(ts.tv_sec * 1000) + ((double)ts.tv_nsec/1000000));
#endif
}

double  pxMicroseconds()
{
#ifndef USE_CGT
    timeval tv;
    gettimeofday(&tv, NULL);
    return (tv.tv_sec * 1000000) + tv.tv_usec;
#else
    timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ((double)(ts.tv_sec * 1000000) + ((double)ts.tv_nsec/1000));
#endif
}

void pxSleepUS(uint64_t usToSleep)
{
    struct timespec res;

    res.tv_sec  = (usToSleep / 1000000UL);
    res.tv_nsec = (usToSleep * 1000UL) % 1000000000UL;

    while (true)
    {
        struct timespec remain;
        const int rv = clock_nanosleep(CLOCK_MONOTONIC, 0, &res, &remain);

        if (rv == 0)
        {
            break;
        }

        if (errno == EINTR)
        {
           res = remain;
           continue;
        }

        // Theoretically impossible case in our case :-)
        // At this point something went wrong but we cannot
        // return any error code as pxSleepMS returns void.
        abort();
    }
}

void pxSleepMS(uint32_t msToSleep)
{
    pxSleepUS(msToSleep * 1000UL);
}

#endif // __cplusplus < 201103L
