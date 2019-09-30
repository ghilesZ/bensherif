#!/bin/bash

function measure(){
    res=$((/usr/bin/time -f "%M %e" $1 $2) 2>&1)
    res=$(echo "$res" | tr ',' '.')
    echo "$res"
}

function plot(){
    rm -f $1
    gnuplot -e "set terminal png size 800,600; set output '$1';\
    set autoscale x; set autoscale y;\
    plot \"results.dat\" using 1:$2 title 'option' with lines,\
    \"results.dat\" using 1:$3 title 'list' with lines,\
    \"results.dat\" using 1:$4 title 'cyclicSum' with lines,\
    \"results.dat\" using 1:$5 title 'cyclicProd' with lines"
}

TIMEFORMAT='%3R'
rm -f results.dat
for i in $(seq 100000 200000 4000000)
do
    to=$(measure ./opt $i)
    tl=$(measure ./list $i)
    tcs=$(measure ./cyclicSum $i)
    tcp=$(measure ./cyclicProd $i)
    echo "$i $to $tl $tcs $tcp" >> results.dat
    echo "$i done"
done

plot ram.png 2 4 6 8
plot time.png 3 5 7 9
