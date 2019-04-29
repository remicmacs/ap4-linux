#! /usr/bin/env bash

declare -A testfiles

# Valid XML test files
testfiles["spec_tag_far_away.xml"]=0
testfiles["one_plant.xml"]=0
testfiles["plant_catalog.xml"]=0
testfiles["one_commented_entry.xml"]=0
testfiles["one_line_comment.xml"]=0

# Parse error test files
testfiles["duplicate_tag.xml"]=19
testfiles["empty_catalog.xml"]=19
testfiles["empty_plant.xml"]=19
testfiles["empty_tagname.xml"]=19
testfiles["empty.xml"]=19
testfiles["no_spec_tag.xml"]=19
testfiles["other_empty_tagname.xml"]=19
testfiles["really_no_spec_tag.xml"]=19
testfiles["unknown_tag.xml"]=19

# Empty file
testfiles["reallyempty.xml"]=11


function check_results () {
    filename=$1
    exit_code=$2
    expected_exit_code=$3

    if [[ $exit_code -eq $expected_exit_code ]]; then
        echo "\"$filename\" :: SUCCESS"
    else
        echo "\"$filename\" :: FAIL"
    fi
}

# Keys of associative arrays are accessed with exclamation point
for filename in ${!testfiles[@]}; do
    cat $filename | ./mhxmlp.sh &> /dev/null
    check_results $filename $? ${testfiles[$filename]}
done