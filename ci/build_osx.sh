#!/bin/sh -x

if [[ ! -z $PX_VERSION ]]
then
  export PX_BUILD_VERSION=$PX_VERSION
fi

checkError()
{
  if [ "$1" -ne 0 ]
  then
  echo "Build failed with errors !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
  echo "CI failure reason: $3"
  if [ "$2" -eq 1 ]
  exit 1;
  fi
}

if [ "$TRAVIS_EVENT_TYPE" != "cron" ] && [ "$TRAVIS_EVENT_TYPE" != "api" ] ;
then
export CODE_COVERAGE=1
fi

cd $TRAVIS_BUILD_DIR;
mkdir temp
cd  temp
if [ "$TRAVIS_PULL_REQUEST" = "false" ]
then

echo "***************************** Generating config files ****"
if [ "$TRAVIS_EVENT_TYPE" != "cron" ] && [ "$TRAVIS_EVENT_TYPE" != "api" ] ;
then
cmake -DBUILD_PX_TESTS=ON -DBUILD_PXSCENE_STATIC_LIB=ON -DBUILD_DEBUG_METRICS=ON .. 2>&1
else
cmake .. 2>&1
fi
checkError $? 0 "cmake config failed"
echo "***************************** Building pxcore,rtcore,pxscene app,libpxscene,unitttests ****"
cmake --build . -- -j1 VERBOSE=1 2>&1
checkError $? 0 "Building either pxcore,rtcore,pxscene app,libpxscene,unitttest failed"

else

echo "***************************** Generating config files ****"
cmake -DBUILD_PX_TESTS=ON -DBUILD_PXSCENE_STATIC_LIB=ON -DBUILD_DEBUG_METRICS=ON .. 2>&1
checkError $? 1  "cmake config failed" "Config error"
echo "***************************** Building pxcore,rtcore,pxscene app,libpxscene,unitttests ****"
cmake --build . -- -j1 VERBOSE=1 2>&1
checkError $? 1 "Building either pxcore,rtcore,pxscene app,libpxscene,unitttest failed"
fi

cd $TRAVIS_BUILD_DIR
if [ "$TRAVIS_PULL_REQUEST" = "false" ]
then
echo "***************************** Building pxscene deploy app ***"

if [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "api" ] ;
then

cd $TRAVIS_BUILD_DIR/examples/pxScene2d/src/

if [[ ! -z $PX_VERSION ]]
then
#make PXVERSION=$PX_VERSION deploy >>$BUILDLOGS 2>&1
#checkError $? 0 "make command failed for deploy target" "Compilation error" "check the $BUILDLOGS file"
echo "built with cmake"
./mkdeploy.sh $PX_VERSION 2>&1

else

if [ "$TRAVIS_EVENT_TYPE" = "cron" ]
then
export linenumber=`awk '/CFBundleShortVersionString/{ print NR; exit }' $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist`
checkError $? 0 "unable to read string CFBundleShortVersionString from Info.plist file"
echo $linenumber
export PX_VERSION=`sed -n "\`echo $((linenumber+1))\`p" $TRAVIS_BUILD_DIR/examples/pxScene2d/src/macstuff/Info.plist|awk -F '<string>' '{print $2}'|awk -F'</string>' '{print $1}'`
checkError $? 0 "unable to read version from Info.plist file"
#make PXVERSION=$PX_VERSION deploy >>$BUILDLOGS 2>&1
./mkdeploy.sh $PX_VERSION 2>&1
checkError $? 0 "make command failed for deploy target"

else
echo "Deploy terminated as pxversion environment is not set for api event type ************* "
checkError 1 1 "Deploy terminated as pxversion environment is not set"
fi

fi

fi

fi
cd $TRAVIS_BUILD_DIR
