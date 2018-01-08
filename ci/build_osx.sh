#!/bin/sh -e

if [[ ! -z $PX_VERSION ]]; then
  export PX_BUILD_VERSION=$PX_VERSION
fi

if [ "$TRAVIS_EVENT_TYPE" != "cron" ] && [ "$TRAVIS_EVENT_TYPE" != "api" ]; then
    export CODE_COVERAGE=1
fi

cd $TRAVIS_BUILD_DIR;
mkdir -p temp
cd  temp

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
    if [ "$TRAVIS_EVENT_TYPE" != "cron" ] && [ "$TRAVIS_EVENT_TYPE" != "api" ]; then
        cmake -DBUILD_PX_TESTS=ON -DBUILD_PXSCENE_STATIC_LIB=ON -DBUILD_DEBUG_METRICS=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DPREFER_SYSTEM_LIBRARIES=${PREFER_SYSTEM_LIBRARIES} ..
    else
        cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DPREFER_SYSTEM_LIBRARIES=${PREFER_SYSTEM_LIBRARIES} ..
    fi

    cmake --build . -- -j$(getconf _NPROCESSORS_ONLN) 2>&1 > build.log || (echo "dumping cmake log:"; cat build.log; exit 1)
else
    cmake -DBUILD_PX_TESTS=ON -DBUILD_PXSCENE_STATIC_LIB=ON -DBUILD_DEBUG_METRICS=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DPREFER_SYSTEM_LIBRARIES=${PREFER_SYSTEM_LIBRARIES} ..
    cmake --build . -- -j$(getconf _NPROCESSORS_ONLN) 2>&1 > build.log || (echo "dumping cmake log:"; cat build.log; exit 1)
fi

cd $TRAVIS_BUILD_DIR

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
    if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
        cd $TRAVIS_BUILD_DIR/examples/pxScene2d/src/
        if [[ ! -z $PX_VERSION ]]; then
            ./mkdeploy.sh $PX_VERSION
        else
            if [ "$TRAVIS_EVENT_TYPE" = "cron" ]; then
                export linenumber=`awk '/CFBundleShortVersionString/{ print NR; exit }' $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist`
                echo $linenumber
                export PX_VERSION=`sed -n "\`echo $((linenumber+1))\`p" $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist|awk -F '<string>' '{print $2}'|awk -F'</string>' '{print $1}'`
                ./mkdeploy.sh $PX_VERSION
            else
                exit 1
            fi
        fi
    fi
fi

cd $TRAVIS_BUILD_DIR
