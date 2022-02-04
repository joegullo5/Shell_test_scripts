#The basic instructions are:
#1) wget that link into your PC02 folder
#2) chmod +x it,
#3) ./test_output.sh make
#4) ./test_output.sh run
#5) Look through the output in the folders it creates. Your programs outputs are in /test/your_outputs and the solutions are in /test/solutions. The program will tell you which files are the same and which are different in the terminal.
#6) When you're done with the output, you can run it as ./test_output.sh clean and it will remove all files and directories it created.
#NOTE there was a problem running it if you have tons of text files in your PC02 folder. Removing these text files will allow the program to run correctly.
#MAKE SURE YOU RUN THIS FROM YOUR PC02

#!/bin/bash
if [ $1 = "clean" ]
then
    rm arguments.txt 2> /dev/null
    rm -r test 2> /dev/null
    exit 1
fi

if [ $1 = "make" ]
then
    echo "Creating file structure"
    mkdir test > /dev/null 2>&1
    mkdir test/inputs test/solutions test/your_outputs
    echo "Getting test files"
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test1.txt --directory-prefix=test/inputs
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test2.txt --directory-prefix=test/inputs
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test3.txt --directory-prefix=test/inputs 
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test4.txt --directory-prefix=test/inputs
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test5.txt --directory-prefix=test/inputs
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test6.txt --directory-prefix=test/inputs 


    echo "Getting Solution files"
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test1_100gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test1_10gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test1_500gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test1_5gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test2_500gen.out --directory-prefix=test/solutions 
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test3_200gen.out --directory-prefix=test/solutions 
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test3_500gen.out  --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test4_100gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test4_200gen.out --directory-prefix=test/solutions 
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test5_100gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test5_200gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test5_500gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test6_100gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test6_200gen.out --directory-prefix=test/solutions
    wget -q https://raw.githubusercontent.com/mmorri22/sp22-cse-20312/main/PC02/test6_500gen.out --directory-prefix=test/solutions
fi

if [ $1 == run ]
then
    echo "Clearing previous answer files..."
    truncate -s 0 test/your_outputs/*.out
    find test/solutions/ -type f > arguments.txt
    sed -i -e "s/^your_outputs//" -e "s/test\/solutions\///" -e "s/^\///" -e "s/$gen.out$//" -e "s/gen$//" -e "s/_/\n/g" arguments.txt


    data=$(cat arguments.txt)
    echo "$data" | while read line; read line1;
    do
        echo " "
        echo "Comparing your $line with the solution for $line1 generations"

        exe/./PC02 "test/inputs/${line}.txt" "$line1" "test/your_outputs/${line}_${line1}gen.out"> /dev/null 2>&1

        if diff -s "test/your_outputs/${line}_${line1}gen.out" "test/solutions/${line}_${line1}gen.out">/dev/null; then
            echo "Success! Identical to the solution"
        elif diff -q "test/your_outputs/${line}_${line1}gen.out" "test/solutions/${line}_${line1}gen.out"; then
            echo "Differences found between your ${line}_${line1}gen.out and the soluctions"
        fi
    done
fi
