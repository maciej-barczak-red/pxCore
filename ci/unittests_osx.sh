#!/bin/sh
ulimit -c unlimited

export HANDLE_SIGNALS=1
export RT_LOG_LEVEL=info

cd $TRAVIS_BUILD_DIR/tests/pxScene2d;
mkdir -p $TRAVIS_BUILD_DIR/logs/
touch $TRAVIS_BUILD_DIR/logs/test_logs;
TESTLOGS=$TRAVIS_BUILD_DIR/logs/test_logs;
time timeout 3m ./pxscene2dtests.sh 2>&1 | tee $TESTLOGS

grep -e '\[' $TESTLOGS

#check for corefile presence
$TRAVIS_BUILD_DIR/ci/check_dump_cores_osx.sh `pwd` `ps -ef | grep pxscene2dtests |grep -v grep|grep -v pxscene2dtests.sh|awk '{print $2}'` $TESTLOGS
retVal=$?
if [ "$retVal" -eq 1 ]; then
    echo "CI failure reason: unittests execution failed - coredump(s) found"
    exit 1;
fi

cd $TRAVIS_BUILD_DIR;

grep -e '\[  PASSED  \]' $TESTLOGS
retVal=$?

if [ "$retVal" -ne 0 ]; then
    echo "CI failure reason: unittests execution failed"
    exit 1;
fi

exit 0

