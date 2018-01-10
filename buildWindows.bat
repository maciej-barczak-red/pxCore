@echo on
@rem  Script to build spark (aka pxscene) on
@rem  Windows platform (locally and on AppVeyor)
@rem
@rem  Author: Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
@rem
@rem
@rem  Assumes the following components are pre-installed:
@rem    - Visual Studio 2017,
@rem    - NSIS,
@rem    - cmake and python 2.7 (also added to PATH).
@rem


cd %~dp0
set "VSCMD_START_DIR=%CD%"
call "C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Auxiliary/Build/vcvars32.bat" x86

@rem build dependencies
cd examples/pxScene2d/external
call buildWindows.bat

cd %~dp0
md temp
cd temp

@rem build pxScene
cmake -DCMAKE_VERBOSE_MAKEFILE=ON ..
cmake --build . --config Release -- /m
cpack .

cd %~dp0
