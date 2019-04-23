#! /bin/env bash

cat /etc/shadow

# Display only lines of users having a password
cat /etc/shadow | grep -v "\:*\:"
cat /etc/shadow | grep -v "^.*:\*"

# Display only first line of file /etc/shadow
cat /etc/shadow | grep -m 1 ""

# gZip recursively all .conf files in /etc subtree
gzip -c /etc/*.conf /etc/**/*.conf > conf.gz

# Display all contents of these files that are not commands or empty lines
gunzip -c conf.gz | grep -v "^#" | grep -v "^$"

# Translation of alphabet -> echo "reboot"
echo "erobbg" | tr '[a-z]' '[t-za-s]'