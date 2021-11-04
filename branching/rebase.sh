#!/bin/bash
# display command line options

count=1
for param in "$@"; do


    echo "\$@ Parameter #$count = $param"
 ef6f50e (rebase: echo)
=======
    echo "\$@ Parameter #$count = $param"
4006a2cab318324f32bfea21c563fc43e32f3bfa
    count=$(( $count + 1 ))
done

echo "====="