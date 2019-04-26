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
has_spec_tag=false
catalog_is_open=false
plant_is_open=false
closing_tag=false

# Check whether line contains XML spec tag or not
function is_spec_tag () {
    $(( has_spec_tag=$(echo $spec_tag | grep -q '<?x') ))
    if has_spec_tag; then
        echo "Found a spec tag"
    fi
}

# Check whether line contains a closing tag or not
function is_closing_tag () {
    echo $1 | grep -q "</"
}

# Check whether a tag is left open or not
# TODO: remove usage by inline test
function is_open () {
   [[ "placeholder$1" == "placeholdertrue" ]];
}

# Check whether the line is empty or not
function is_empty_line () {
    [ "placeholder$1" = "placeholder" ];
}

# Parse a read line to extract tagname and tag content
function parse_line () {
    # echo $line;

    # Get tagname by capturing content of the first tag of the line
    tagname=$(echo $line | sed -rn 's/.*<\/?([^<>/]*)>.*/\1/p')

    if [[ "placeholder$tagname" == "placeholder" ]]; then
        parse_error "Empty Tagname"
    fi

    # echo "Found tagname \"$tagname\""

    # Get tag content
    # If the line contains a malformed XML field, it will contain nothing
    tag_content=$(echo $line | sed -rn "s/.*<$tagname>([^<]*)<\/$tagname>.*/\1/p")

    # echo "Content is : \"$tag_content\""

    case $tagname in

        "CATALOG")
            # echo "Checking opening/closing tag";
            if is_closing_tag "$line" && [[ "placeholder$catalog_is_open" == "placeholderfalse" ]]; then
                parse_error "Closing a closed catalog"
            fi

            # DO STG

            # echo "Toggling catalog state";
            if is_open $catalog_is_open ; then
                # echo "Catalog was open, closing it"
                catalog_is_open=false
            else
                # echo "Catalog was closed, opening it"
                catalog_is_open=true
            fi
        ;;
        "PLANT")
            if is_closing_tag "$line" && [[ "placeholder$plant_is_open" == "placeholderfalse" ]]; then
                parse_error "Closing a closed plant entry"
            fi


            # DO STG
            # echo "Toggling plant state";
            if is_open $plant_is_open ; then
                # echo "Plant was open, closing it"
                plant_is_open=false
            else
                # echo "Plant was closed, opening it"
                plant_is_open=true
            fi
        ;;
        *) process_tag $tagname "$tag_content";;
    esac

}

# Extract information from a regular tag
function process_tag () {
    tagname=$1
    tag_content=$2

    if [[  "placeholder$tag_content" == "placeholder" ]]; then
        parse_error "Malformed Plant XML Tag or empty value"
    fi

    # echo "Tagname is \"$tagname\""

    # echo "Content is : \"$tag_content\""

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
line_nb=$((line_nb + 1))
# If there is no such tag, then the XML must be an empty file
if $empty_file; then
    error_message "Error: Standard input stream was empty"
    usage
    exit 11
fi

# echo "Line found $spec_tag"
# echo $spec_tag | grep '<?x'
echo $spec_tag | grep -q '<?x' && has_spec_tag=true

# while [[ ! $(echo $spec_tag | grep -q '<?xml') ]]; do*
until [[ "$has_spec_tag" = "true" ]]; do
    # echo "Line found $spec_tag"
    read spec_tag || parse_error "No XML Spec Tag found"
    line_nb=$((line_nb + 1))
    # echo $spec_tag | grep '<?x'
    echo $spec_tag | grep -q '<?x' && has_spec_tag=true
done

line_nb=0
plants_nb=0
while read line; do
    if is_empty_line $line ; then
        continue
    fi
    parse_line $line
    line_nb=$((line_nb + 1))
done

# Check if file was empty
if [ $line_nb -eq 0 ]; then
    parse_error "The XML document was empty"
elif [ $plants_nb -eq 0 ]; then
    parse_error "The catalog was empty"
fi