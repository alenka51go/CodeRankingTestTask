#!/bin/bash

touch methodRef
touch classAndFunctionRef
touch className
touch functionName
touch out
touch constantPool

javap -c -p -v $1 | grep -P "^[ ]*#\d* = " > constantPool
javap -c -p $1 | grep invokevirtual | grep -oP "#\d+" | sort -u > methodRef

for var in $(cat methodRef)
do
    cat constantPool | grep -P "^[ ]*$var = " | grep -oP '#\d+.#\d+' | tr "." "\n" >> classAndFunctionRef
done

sort -u classAndFunctionRef > out
cat out > classAndFunctionRef
cat /dev/null > out

for var in $(cat classAndFunctionRef)
do
    cat constantPool | grep -P "^[ ]*$var = " | grep Class | sed -r 's/[ ]*#[0-9]* = Class[ ]*(#[0-9]+).*/\1/' >> className
    cat constantPool | grep -P "^[ ]*$var = " | grep NameAndType | grep -oP '#\d+:#\d+' | tr ":" "\n" >> functionName
done

sed '1d; n; d' -i functionName

sort -u className > out
cat out > className
sort -u functionName > out
cat out > functionName
cat /dev/null > out

for var in $(cat className)
do
    cat constantPool | grep -P "^[ ]*$var = " | sed -r 's/[ ]*#[0-9]* = Utf8[ ]*([^ ]+).*/\1/' >> out
done

for var in $(cat functionName)
do
    cat constantPool | grep -P "^[ ]*$var = " | sed -r 's/[ ]*#[0-9]* = Utf8[ ]*([^ ]+).*/\1/' | sed -r 's/\((.*)\)[^L]/\1/' | sed -r 's/\((.*)\)(L.*;)/\2\1/' | tr ";" "\n" | grep -P "L.*" | sed -r 's/L(.*)/\1/' >> out
done

cat out | sort -u

rm functionName
rm constantPool
rm classAndFunctionRef
rm methodRef
rm className
rm out

