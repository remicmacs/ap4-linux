#!/usr/bin/env bash

# Const declaration
shell=/bin/bash
last_pw_check=17968

# Check command arguments
if [ $# -ne 4 ]; then
    echo "Error in arguments"
    exit 1
fi

if id -u "$1" &> /dev/null; then
    echo "User already exists"
    exit 1
fi

if [[ $2 =~ ^[^0-9]+$ ]]; then
    echo "Error: UID should only be a number"
    exit 1
elif [[ $3 =~ ^[^0-9]+$ ]]; then
    echo "Error: GID should only be a number"
    exit 1
fi


if getent passwd $2 &>/dev/null; then
    echo "UID already in use"
    exit 1
elif [ $2 -lt 1000 ]; then
    echo "Reserved UID"
    exit 1
fi

if getent group $3 &>/dev/null; then
    echo "GID already in use"
    exit 1
elif [ $3 -lt 1000 ]; then
    echo "Reserved GID"
    exit 1
fi

# Add line to /etc/passwd
passwd_line="$1:x:$2:$3::/home/$1:$shell"
# echo "Password line :"
# echo $passwd_line

random=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5)
hash=$(openssl passwd -1 -salt $random $4)
shadow_line="$1:$hash:$last_pw_check:0:99999:7:::"

# echo "Shadow line"
# echo $shadow_line

group_line="$1:x:$3:$1"

# echo "Group line"
# echo $group_line

echo $group_line >> /etc/group

echo $passwd_line >> /etc/passwd

echo $shadow_line >> /etc/shadow

cp -R /etc/skel /home/$1

chown -R $1:$1 /home/$1