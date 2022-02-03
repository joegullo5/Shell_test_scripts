#!/bin/bash
echo "Clearing previous answer files..."
truncate -s 0 your_outputs/*.out
rm *txt
find your_outputs -type f > arguments.txt
sed -i -e "s/^your_outputs//" -e "s/^\///" -e "s/$gen.out$//" -e "s/gen$//" -e "s/_/\n/g" arguments.txt


data=$(cat arguments.txt)

echo "$data" | while read line; read line1;
do
    echo " "
    echo "Comparing your $line with the solution for $line1 generations"
    ../exe/./PC02 "inputs/$line.txt" "$line1" "your_outputs/${line}_${line1}gen.out"> /dev/null
    if diff -s "your_outputs/${line}_${line1}gen.out" "solutions/${line}_${line1}gen.out">/dev/null; then
        echo "Success! Identical to the solution"
    elif diff -q "your_outputs/${line}_${line1}gen.out" "solutions/${line}_${line1}gen.out"; then
        echo "Differences found between your ${line}_${line1}gen.out and the soluctions"
    fi

done

rm *txt

