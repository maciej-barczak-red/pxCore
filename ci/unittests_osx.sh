#!/bin/sh
checkError()
{
  if [ "$1" -ne 0 ]
  then
    printf "\n\n*********************************************************************";
    printf "\n*******************CODE COVERAGE FAIL DETAILS************************";
    printf "\nCI failure reason: $2"
    printf "\nCause: $3"
    printf "\nReproduction/How to fix: $4"
    printf "\n*********************************************************************";
    printf "\n*********************************************************************\n\n";
    exit 1
  fi
}

ulimit -c unlimited

export HANDLE_SIGNALS=1
export RT_LOG_LEVEL=info

cd $TRAVIS_BUILD_DIR/tests/pxScene2d;
mkdir -p $TRAVIS_BUILD_DIR/logs/
touch $TRAVIS_BUILD_DIR/logs/test_logs;
TESTLOGS=$TRAVIS_BUILD_DIR/logs/test_logs;
TIMEOUT=$(which timeout || which gtimeout)

$TIMEOUT 3m ./pxscene2dtests.sh 2>&1 | tee $TESTLOGS

grep -e '\[' $TESTLOGS

#check for corefile presence
$TRAVIS_BUILD_DIR/ci/check_dump_cores_osx.sh `pwd` `ps -ef | grep pxscene2dtests |grep -v grep|grep -v pxscene2dtests.sh|awk '{print $2}'` $TESTLOGS
retVal=$?
if [ "$retVal" -eq 1 ]; then
    echo "CI failure reason: unittests execution failed - coredump(s) found"
    exit 1;
fi

cd $TRAVIS_BUILD_DIR;

grep -e '\[  FAILED  \]' $TESTLOGS
retVal=$?

if [ "$retVal" -eq 0 ]; then
    echo "CI failure reason: unittests execution failed"
    exit 1;
fi

exit 0

