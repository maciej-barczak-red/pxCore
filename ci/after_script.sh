#!/bin/sh -ex

if [ "$TRAVIS_CREATE_CACHE_ONLY" = "true" ]; then
    echo "Ignoring script stage for cache creation event";
    exit 0
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    echo "Ignoring after script stage for $TRAVIS_EVENT_TYPE event";
    exit 0;
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    export PATH=$PATH:$HOME/Library/Python/2.7/bin
fi

if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
    if [ "$TRAVIS_OS_NAME" = "linux" ]; then
        export DISPLAY=:99.0
        /bin/sh -e /etc/init.d/xvfb start
        sleep 3
    fi

    cd $TRAVIS_BUILD_DIR/ci

    /bin/sh -x "./unittests_$TRAVIS_OS_NAME.sh"
    /bin/sh -x "./execute_$TRAVIS_OS_NAME.sh"
    /bin/sh -x "./code_coverage_$TRAVIS_OS_NAME.sh"
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    cp $TRAVIS_BUILD_DIR/examples/pxScene2d/src/deploy/mac/*.dmg $TRAVIS_BUILD_DIR/artifacts/.
    cp $TRAVIS_BUILD_DIR/examples/pxScene2d/src/deploy/mac/software_update.plist $TRAVIS_BUILD_DIR/artifacts/.
fi

if [ "$TRAVIS_EVENT_TYPE" = "push" ] || [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]; then
    codecov --build "$TRAVIS_OS_NAME-$TRAVIS_COMMIT-$TRAVIS_BUILD_NUMBER" -X gcov -f $TRAVIS_BUILD_DIR/tracefile
    genhtml -o $TRAVIS_BUILD_DIR/logs/codecoverage $TRAVIS_BUILD_DIR/tracefile
fi

cd $TRAVIS_BUILD_DIR

if [ "$TRAVIS_EVENT_TYPE" = "push" ]; then
    tar -cvzf logs.tgz logs/*
    ./ci/deploy_files.sh 96.116.56.119 logs.tgz
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    mkdir -p release
    mv logs release/.
    mv artifacts release/.
    tar -cvzf release.tgz release/*
    ./ci/release_osx.sh 96.116.56.119 release.tgz
fi

#update release  notes and info.plist in github
if [ "$TRAVIS_EVENT_TYPE" = "api" ] && [ "$UPDATE_VERSION" = "true" ]; then
    git checkout master
    export linenumber=`awk '/CFBundleShortVersionString/{ print NR; exit }' $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist`
    echo $linenumber
    sed -i '.bak' "`echo $((linenumber+1))`s/.*/       <string>$PX_VERSION<\\/string>/g" $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist
    cp $TRAVIS_BUILD_DIR/RELEASE_NOTES $TRAVIS_BUILD_DIR/RELEASE_NOTES_bkp
    echo "===============================================================\n\nRelease $PX_VERSION - `date +\"%d%b%Y\"`\n\n(github.com/johnrobinsn/pxCore: master - SHA `git log --oneline|head -n 1|awk '{print $1}'`)\n\nKnown Issues:\n\nCommits/Fixes:\n" > $TRAVIS_BUILD_DIR/RELEASE_NOTES
    git log  `git log --grep="Change version for release" --oneline -n 1|awk '{print $1}'`..HEAD --oneline --format=%s --no-merges >> $TRAVIS_BUILD_DIR/RELEASE_NOTES
    echo "\n\n" >> $TRAVIS_BUILD_DIR/RELEASE_NOTES
    cat $TRAVIS_BUILD_DIR/RELEASE_NOTES_bkp >> $TRAVIS_BUILD_DIR/RELEASE_NOTES
    rm -rf $TRAVIS_BUILD_DIR/RELEASE_NOTES_bkp
    git add $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist
    git add $TRAVIS_BUILD_DIR/RELEASE_NOTES
    git commit -m "Change version for release $PX_VERSION [skip ci]"
    git push --repo="https://$REPO_USER_NAME:$GH_TOKEN@github.com/$REPO_USER_NAME/$REPO_NAME.git"
fi
