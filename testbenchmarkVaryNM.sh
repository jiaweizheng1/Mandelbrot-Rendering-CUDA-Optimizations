#! /bin/bash

for (( i = 32; i <= 1024; i *= 2))
do
    for ((j = 32; j <= 1024; j *= 2))
    do
        echo `./benchmark $i $j`
    done
done
