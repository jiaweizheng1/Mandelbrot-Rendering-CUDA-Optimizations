#! /bin/bash

for (( i = 32; i <= 512; i += 32))
do
    echo `./benchmark $i`
done
