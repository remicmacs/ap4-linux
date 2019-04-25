#! /usr/bin/env bash

var=1
while `true`
do
    echo $var
    sleep 0.1
    var=$((var+1))
done