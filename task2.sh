#!/bin/bash

touch temp
touch temp2
touch temp3
touch constantPool

javap -c -p -v $1 | grep -P "^[ ]*#[0-9]* = " > constantPool
javap -p $1 | grep invokevirtual | grep -oP "#\d+" > temp

for var in $(cat temp)
do
    cat constantPool | grep -P "^[ ]*$var = " | grep -oP '#\d+.#\d+' | tr "." "\n" >> temp2
done

sort -u temp2 > temp
cat /dev/null >  temp2

for var in $(cat temp)
do
    cat constantPool | grep -P "^[ ]*$var = " | grep Class | sed -r 's/[ ]*#[0-9]* = Class[ ]*(#[0-9]+).*/\1/' >> temp2
done

for var in $(cat temp2)
do
    cat constantPool | grep -P "^[ ]*$var = " | sed -r 's/[ ]*#[0-9]* = Utf8[ ]*([^ ]+).*/\1/' >> temp3
done

cat /dev/null >  temp2

for var in $(cat temp)
do
    cat constantPool | grep -P "^[ ]*$var = " | grep NameAndType | grep -oP '#\d+:#\d+' | tr ":" "\n" >> temp2
done

sed '1d; n; d' -i temp2

for var in $(cat temp2)
do
    cat constantPool | grep -P "^[ ]*$var = " | sed -r 's/[ ]*#[0-9]* = Utf8[ ]*([^ ]+).*/\1/' | sed -r 's/\((.*)\)[^L]/\1/' | sed -r 's/\((.*)\)(L.*;)/\2\1/' | tr ";" "\n" | grep -P "L.*" | sed -r 's/L(.*)/\1/' >> temp3
done

cat temp3 | sort -u

rm constantPool
rm temp2
rm temp
rm temp3

