#! /usr/bin/env bash

# Function to display usage of script
function usage () {
    cat <<EOF
mhxmlp.sh - Horrible Bash XML parser for plant documents
    ---
usage : cat mydoc.xml | ./mhxmlp.sh
    Does not takes any arguments, reads on standard input

Reference XML document template available at :
https://www.w3schools.com/xml/plant_catalog.xml

PLEASE NOTE : ALL LINES SHOULD BE TERMINATED BY A NEWLINE CHARACTER

Please do not report bugs, they are features.
EOF
}

# Display error message
function error_message () {
    echo $1
    echo
}

# Parse error function : displays the error message and exits 19
function parse_error () {
    echo "Parse Error: $1"
    exit 19
}


# Check if any arguments are used
if [ $# -ne 0 ]; then
    error_message "Error: Too many arguments"
    usage
    exit 5
fi

# Stripping XML spec tag
empty_file=false
read spec_tag|| empty_file=true
# If there is no such tag, then the XML must be an empty file
if $empty_file; then
    error_message "Error: Standard input stream was empty"
    usage
    exit 11
fi

# Check for spec tag
if $(echo $spec_tag | grep -vq version); then
    error_message "Parse Error: XML Spec Tag not found"
    usage
    exit 19
fi

line_nb=0
plants_nb=0
while read line; do
    echo $line;

    # Get tagname by capturing content of the first tag of the line
    tagname=$(echo $line | sed -rn 's/.*<\/?([^<>/]*)>.*/\1/p')

    echo "Found tagname \"$tagname\""

    tag_content=$(echo $line | sed -rn "s/.*<$tagname>([^<]*)<\/$tagname>.*/\1/p")

    echo "Content is : \"$tag_content\""
    line_nb=$((line_nb + 1))
done

# Check if file was empty
if [ $line_nb -eq 0 ]; then
    parse_error "The XML document was empty"
elif [ $plants_nb -eq 0 ]; then
    parse_error "The catalog was empty"
fi