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

# Parse error function : displays the error message and exits 19
function parse_error () {
    (>&2 echo "Parse Error: $1")
    exit 19
}

# Test functions, because it is way more legible than inline regexp
# Check whether line contains XML spec tag or not
function is_spec_tag () {
    [[ "$1" =~ "<?xml" ]];
}

# Check whether line contains a closing tag or not
function is_closing_tag () {
    [[ $1 =~ "</" ]]
}

# Check whether a tag is left open or not
function is_open () {
   [[ "$1" == "true" ]];
}

# Check whether the line is empty or not
function is_empty_line () {
    [[ "$1" == "" ]];
}

# Check whether line is a comment or not
function is_comment () {
    [[ "$1" =~ (.*<\!--.*) ]];
}

function find_closing_comment () {
    local line=$1

    until [[ "$line" =~ (.*-->$) ]]; do
        read -r line
    done
}

# Parse a line passed by parameter
function parse () {
    # Protection from scope shadowing
    local line="$1"

    # Get tagname by capturing content of the first tag of the line
    local tagname
    tagname=$(sed <<< "$line" -rn 's/.*<\/?([^<>/]*)>.*/\1/p')

    if [[ "$tagname" == "" ]]; then
        parse_error "Empty Tagname"
    fi

    # Get tag content
    # If the line contains a malformed XML field, it will contain nothing
    local tag_content
    tag_content=$(sed <<< "$line" -rn \
        "s/.*<$tagname>([^<]*)<\/$tagname>.*/\1/p")

    case $tagname in
        "CATALOG")
            if is_closing_tag "$line" \
                && [[ "$catalog_is_open" == "false" ]]; then
                parse_error "Closing a closed catalog"
            fi

            # Toggle catalog state
            if is_open "$catalog_is_open" ; then
                catalog_is_open=false
            else
                catalog_is_open=true
            fi;;
        "PLANT")
            if is_closing_tag "$line" && [[ "$plant_is_open" == "false" ]]; then
                parse_error "Closing a closed plant entry"
            fi

            if ! is_open "$plant_is_open" ; then
                plant_is_open=true
                parse_plant_entry
            fi;;
        *) parse_error "Malformed XML - Tag outside PLANT or CATALOG entry";;
    esac
}

# Parse a plant entry
function parse_plant_entry () {
    # Associative array for all plant subfields
    declare -A plant_array

    local line
    while read -r line; do
        # Stripping empty lines and comments
        if is_comment "$line"; then
            find_closing_comment "$line"
            continue
        elif is_empty_line "$line"; then
            continue
        fi

        ((line_nb += 1))

        # Get tagname by capturing content of the first tag of the line
        local tagname
        tagname=$(sed <<< "$line" -rn 's/.*<\/?([^<>/]*)>.*/\1/p')

        if [[ "$tagname" == "" ]]; then
            parse_error "Empty Tagname"
        fi

        # End of plant entry found
        if [[ $tagname = "PLANT" ]] && is_closing_tag "$line"; then
            break
        fi

        # Get tag content
        # If the line contains a malformed XML field, it will contain nothing
        local tag_content
        tag_content=$(sed <<< "$line" -rn \
            "s/.*<$tagname>([^<]*)<\/$tagname>.*/\1/p")

        if [[ "$tag_content" == "" ]]; then
            parse_error "Malformed XML Tag or Empty Tag"
        fi

        # Check if tag has already a value for this plant
        if [[ ${plant_array[$tagname]} != "" ]]; then
            parse_error "Duplicate tag $tagname"
        else
            case $tagname in
                # List of authorized tagnames
                COMMON|BOTANICAL|ZONE|LIGHT|PRICE|AVAILABILITY)
                    plant_array[$tagname]=$tag_content;;
                # Any other raise a malformed XML error
                *) parse_error "Unknown tag \"$tagname\"";;
            esac
        fi
    done

    # Setting plant state to closed
    plant_is_open=false

    # Last check : a plant entry is only valid with a COMMON value
    if [[ "${plant_array[COMMON]}" == "" ]]; then
        parse_error "Empty COMMON tag in PLANT entry"
    fi

    ((plants_nb+=1))

    # Display plant entry
    echo -n "${plant_array[COMMON]};${plant_array[BOTANICAL]};"
    echo -n "${plant_array[ZONE]};${plant_array[LIGHT]};${plant_array[PRICE]};"
    echo "${plant_array[AVAILABILITY]}"
}

# Main {

# Global boolean flags
has_spec_tag=false
catalog_is_open=false
plant_is_open=false

line_nb=0

# Check if any arguments are used
if [ $# -ne 0 ]; then
    (>&2 echo "Error: Too many arguments")
    usage
    exit 5
fi

# Searching XML spec tag
empty_file=false
read -r spec_tag || empty_file=true
# If the read call has failed, then stdin must be an empty stream
if $empty_file; then
    (>&2 echo "Error: Standard input stream was empty")
    usage
    exit 11
fi

# Here, stdin is not an empty stream
# Keep looking for XML spec tag
is_spec_tag "$spec_tag" && has_spec_tag=true
until [[ "$has_spec_tag" = "true" ]]; do
    read -r spec_tag || parse_error "No XML Spec Tag found"
    is_spec_tag "$spec_tag" && has_spec_tag=true
done

plants_nb=0
while read -r line; do
    # Stripping empty lines and comments
    if is_empty_line "$line"; then
        continue
    elif is_comment "$line"; then
        find_closing_comment "$line"
        continue
    fi

    ((line_nb += 1))

    parse "$line"
done

# Check if file was empty
if [ $line_nb -eq 0 ]; then
    parse_error "The XML document was empty"
elif [ $plants_nb -eq 0 ]; then
    parse_error "The catalog was empty"
fi

# } # End of Main