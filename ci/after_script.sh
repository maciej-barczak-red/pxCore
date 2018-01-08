#!/bin/sh -ex

if [ "$TRAVIS_CREATE_CACHE_ONLY" = "true" ]; then
    echo "Ignoring script stage for cache creation event";
    exit 0
fi

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ]; then
    echo "Ignoring after script stage for $TRAVIS_EVENT_TYPE event";
    exit 0;
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
