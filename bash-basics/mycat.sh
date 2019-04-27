#! /bin/env bash

line_nb = 0

for file in $@
do
    while read line; do
        echo $line
        line_nb=$((line_nb + 1))
    done < $file
done

exit $line_nb