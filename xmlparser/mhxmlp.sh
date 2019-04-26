#! /usr/bin/env bash

# Function to display usage of script
function usage () {
    cat >&2 <<EOF
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

# Global boolean flags
# 0 is true and 1 is false
catalog_is_open=1
plant_is_open=1
closing_tag=1

function is_closing_tag () {
    echo $1 | grep -q "</"
}

function is_closed () {
    if [[ $catalog_is_open -eq 0 ]]; then
        echo "Tag is open"
    else
        echo "Tag is closed"
    fi
}

function parse_line () {
    echo $line;

    # Get tagname by capturing content of the first tag of the line
    tagname=$(echo $line | sed -rn 's/.*<\/?([^<>/]*)>.*/\1/p')

    # echo "Found tagname \"$tagname\""

    tag_content=$(echo $line | sed -rn "s/.*<$tagname>([^<]*)<\/$tagname>.*/\1/p")

    # echo "Content is : \"$tag_content\""

    case $tagname in

        "CATALOG")
            # echo "Checking opening/closing tag";
            is_closing_tag "$line"
            closing_tag=$?

            if [[ ! $closing_tag -eq catalog_is_open ]]; then
                parse_error "Closing a closed catalog"
                exit 19
            fi

            # DO STG

            # echo "Toggling catalog state";
            ((catalog_is_open ^= 1));
            is_closed $catalog_is_open
        ;;
        "PLANT")
            echo "Checking opening/closing tag";
            is_closing_tag "$line"
            closing_tag=$?

            if [[ ! $closing_tag -eq plant_is_open ]]; then
                parse_error "Closing a closed plant entry"
                exit 19
            fi


            # DO STG
            # echo "Toggling plant state";
            ((plant_is_open ^= 1));
            is_closed $catalog_is_open
        ;;
        *) process_tag $tagname "$tag_content";;
    esac

}

function process_tag () {
    tagname=$1
    tag_content=$2

    echo "Tagname is \"$tagname\""

    echo "Content is : \"$tag_content\""

    case $tagname in
        "COMMON");;
        "BOTANICAL");;
        "ZONE");;
        "LIGHT");;
        "PRICE");;
        "AVAILABILITY");;
        *) parse_error "Unknown tag \"$tagname\"";;
    esac
}

# Display error message
function error_message () {
    (>&2 echo $1)
    echo
}

# Parse error function : displays the error message and exits 19
function parse_error () {
    (>&2 echo "Parse Error: $1")
    exit 19
}


# Check if any arguments are used
if [ $# -ne 0 ]; then
    error_message "Error: Too many arguments"
    usage
    exit 5
fi

# Stripping XML spec tag
# TODO: Do a while loop until spec is found
empty_file=false
read spec_tag || empty_file=true
# If there is no such tag, then the XML must be an empty file
if $empty_file; then
    error_message "Error: Standard input stream was empty"
    usage
    exit 11
fi

echo "Line found $spec_tag"
while [[ ! $(echo $spec_tag | grep -q '<?') ]]; do
    read spec_tag || parse_error "XML Spec Tag not found" || exit 19
    echo "Line found $spec_tag"
done

line_nb=0
plants_nb=0
while read line; do
    parse_line $line
    line_nb=$((line_nb + 1))
done

# Check if file was empty
if [ $line_nb -eq 0 ]; then
    parse_error "The XML document was empty"
elif [ $plants_nb -eq 0 ]; then
    parse_error "The catalog was empty"
fi