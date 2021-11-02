#!/bin/bash
# display command line options

count=1
for param in "$@"; do

    echo "\$@ Parameter #$count = $param"
 ef6f50e (rebase: echo)
    count=$(( $count + 1 ))
done

echo "====="