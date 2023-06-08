#! /bin/bash

for (( j = 32; j <= 512; j += 32))
do
    echo `./benchmark 512 $j`
done
