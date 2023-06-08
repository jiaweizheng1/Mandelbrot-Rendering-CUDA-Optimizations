#! /bin/bash

for (( i = 32; i <= 512; i += 32))
do
    for ((j = 32; j <= 512; j += 32))
    do
        echo `./benchmark $i $j`
    done
done
