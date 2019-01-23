#!/bin/sh

# arguements
# $1: name of input file
# $2: name of output file

# global variables
TEST_NAME='{ print $1 }'
TEST_DESC='{ print $2 }'
TEST_RULE='{ print $3 }'
TEST_TOOL='{ print $4 }'
TEST_EXP_RESULT='{ print $5 }'
TEST_CMD='{ print $6 }'

# functions
# takes a single line from input file and run the test case
# $1: the line from the input file
run_test_case()
{
    echo "Test:"
    echo $1 | awk -F',' "$TEST_NAME"
    echo
    echo "Test Description:"
    echo $1 | awk -F',' "$TEST_DESC"
    echo
    echo "Rule:"
    echo $1 | awk -F',' "$TEST_RULE"
    echo
    echo "Tool Used:"
    echo $1 | awk -F',' "$TEST_TOOL"
    echo
    echo "Pass or Fail"
    echo "[placeholder]"
    echo
    echo "Proof:"
    echo "[placeholder]"
    echo
    echo
    echo
    echo
}

while read line
do
    run_test_case $line
done < $1