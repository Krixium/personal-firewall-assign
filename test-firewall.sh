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

# make dump and image folders
rm -rf dumps
rm -rf logs
mkdir dumps
mkdir logs

while read line
do
    test_name=$(echo $line | awk -F',' '{ print $1 }')
    test_desc=$(echo $line | awk -F',' '{ print $2 }')
    test_rule=$(echo $line | awk -F',' '{ print $3 }')
    test_tool=$(echo $line | awk -F',' '{ print $4 }')
    test_exp_result=$(echo $line | awk -F',' '{ print $5 }')
    test_script=$(echo $line | awk -F',' '{ print $6 }')
    test_filter=$(echo $line | awk -F',' '{ print $7 }')
    test_logs="logs: logs/$test_name.txt"
    test_dump="tcpdump: logs/$test_name.pcap"

    clear
    tshark -q -a duration:2 -Y $test_filter -w "dumps/$test_name.pcap"&
    ./$test_script > "logs/$test_name.txt"
    sleep 3
    clear
    # import -window root -crop '960x980+0+0' "images/$test_name.png"
    # kill $(ps -e | pgrep tshark)

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