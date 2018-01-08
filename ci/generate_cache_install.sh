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

#install necessary basic packages for linux and mac
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    travis_retry sudo apt-get update
    travis_retry sudo apt-get install git libglew-dev freeglut3 freeglut3-dev libgcrypt11-dev zlib1g-dev g++ libssl-dev nasm autoconf valgrind libyaml-dev lcov cmake  lighttpd gdb quilt
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    export HOMEBREW_NO_AUTO_UPDATE=1
    sudo /usr/sbin/DevToolsSecurity --enable
    brew install ccache
fi
