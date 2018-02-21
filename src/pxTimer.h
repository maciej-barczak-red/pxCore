/*

   pxCore Copyright 2005-2018 John Robinson

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/

// pxTimer.h

#ifndef PX_TIMER_H
#define PX_TIMER_H

#include <inttypes.h>

/* helper function */
inline uint64_t uint64_diff(const uint64_t x, const uint64_t y)
{
  return x >= y ? x - y : y - x;
}

#if __cplusplus >= 201103L // {
    // Common implementation for all modern platforms supporting >= c++11

#   include <chrono>
#   include <ratio>
#   include <thread>

    inline uint64_t pxMicroseconds()
    {
        auto t_now = std::chrono::high_resolution_clock::now();
        auto t_us = std::chrono::time_point_cast<std::chrono::microseconds>(t_now).time_since_epoch();
        return t_us.count();
    }

    inline uint64_t pxMilliseconds()
    {
        return pxMicroseconds() / 1000;
    }

    inline uint64_t pxSeconds()
    {
        return pxMilliseconds() / 1000;
    }

    inline void pxSleepUS(const uint64_t usToSleep)
    {
        std::this_thread::sleep_for(std::chrono::microseconds(usToSleep));
    }

    inline void pxSleepMS(const uint32_t msToSleep)
    {
        pxSleepUS(msToSleep * 1000UL);
    }
#else // }{
    // Legacy, platform specific, implementation for old platforms not supporting c++11
    uint64_t pxMicroseconds();
    uint64_t pxMilliseconds();
    uint64_t pxSeconds();

    void pxSleepMS(uint32_t msToSleep);
    void pxSleepUS(uint64_t usToSleep);
#endif // } __cplusplus >= 201103L

#endif // PX_TIMER_H
