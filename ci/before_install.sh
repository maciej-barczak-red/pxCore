#!/bin/sh -ex

travis_retry() {
    local result=0
    local count=1
    while [ $count -le 3 ]; do
        [ $result -ne 0 ] && {
            echo -e "\n$The command \"$@\" failed *******************. Retrying, $count of 3.\n" >&2
        }
        "$@"
        result=$?
        [ $result -eq 0 ] && break
        count=$(($count + 1))
        sleep 1
    done

    [ $count -gt 3 ] && {
        echo -e "\n$The command \"$@\" failed 3 times *******************.\n" >&2
    }

    return $result
}

#start the monitor
$TRAVIS_BUILD_DIR/ci/monitor.sh &

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
        echo "Ignoring before install stage for $TRAVIS_EVENT_TYPE event";
        exit 0;
    fi
fi

if [ "$TRAVIS_PREFER_SYSTEM_LIBRARIES" = "ON" ]; then
    export PREFER_SYSTEM_LIBRARIES=ON
else
    export PREFER_SYSTEM_LIBRARIES=OFF
fi

#install necessary basic packages for linux and mac
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    if [ "$PREFER_SYSTEM_LIBRARIES" = "ON" ]; then
        linux_comm_deps="zlib1g-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libfreetype6-dev"
    fi

    travis_retry sudo apt-get update
    travis_retry sudo apt-get install git libglew-dev freeglut3 freeglut3-dev \
        libgcrypt11-dev zlib1g-dev g++ libssl-dev nasm autoconf valgrind \
        libyaml-dev lcov cmake gdb quilt python-pip ${linux_comm_deps}
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    sudo /usr/sbin/DevToolsSecurity --enable
    lldb --version
fi

#install ccache coreutils and code coverage binaries for mac
if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
        if [ "PREFER_SYSTEM_LIBRARIES" = "ON" ]; then
            osx_comm_deps="zlib curl jpeg libpng freetype"
        fi

        HOMEBREW_NO_AUTO_UPDATE=1 brew install ccache coreutils gcovr lcov ${osx_comm_deps}
    fi
fi

#install codecov
if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
    if [ "$TRAVIS_OS_NAME" = "osx" ]; then
        git clone https://github.com/pypa/pip
        sudo easy_install pip
    fi

    sudo pip install codecov
fi
