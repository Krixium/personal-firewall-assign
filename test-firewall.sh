#!/bin/sh

input_file=$1
output_file=$2

# appends $1 to the output file
output_to_file()
{
    echo $1 >> $output_file
}

# clear output file
echo "" > $output_file

while read line
do
    test_name=$(echo $line | awk -F',' '{ print $1 }')
    test_desc=$(echo $line | awk -F',' '{ print $2 }')
    test_rule=$(echo $line | awk -F',' '{ print $3 }')
    test_tool=$(echo $line | awk -F',' '{ print $4 }')
    test_exp_result=$(echo $line | awk -F',' '{ print $5 }')
    test_script=$(echo $line | awk -F',' '{ print $6 }')
    test_filter=$(echo $line | awk -F',' '{ print $7 }')
    test_screenshot="Screenshot: $test_name.png"
    test_dump="tcpdump: $test_name.pcap"

    clear
    # start tcpdump
    ./tcpdump& -F $test_filter -w $test_dump
    clear
    # run TEST_CMD
    ./$test_script
    # screen shot ouptut
    import import -window root -crop '960x980+0+0' $test_screenshot
    # stop tcpdump
    kill $(ps -e | pgrep tcpdump)

    output_to_file "Test:"
    output_to_file "$test_name"
    output_to_file
    output_to_file "Test Description:"
    output_to_file "$test_desc"
    output_to_file
    output_to_file "Rule:"
    output_to_file "$test_rule"
    output_to_file
    output_to_file "Tool Used:"
    output_to_file "$test_tool"
    output_to_file
    output_to_file "Expected Result:"
    output_to_file "$test_exp_result"
    output_to_file
    output_to_file "Pass or Fail"
    output_to_file "Pass"
    output_to_file
    output_to_file "Proof:"
    output_to_file "$test_screenshot"
    output_to_file "$test_dump"
    output_to_file
    output_to_file
    output_to_file
done < $1