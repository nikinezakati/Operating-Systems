#! /bin/bash

FILE_NAME=$1

while read -r CURRENT_LINE
do
    LINE=$(echo $CURRENT_LINE | cut -d " " -f1)
    NUM=$(echo $CURRENT_LINE | cut -d " " -f2-)
    for N in $NUM
    do
        if [ "$N" -lt "50" ]
        then
            RESULT="Fail"
            break
        else
            RESULT="Pass"    
        fi  
    done
    echo "$LINE: $RESULT"
done < $FILE_NAME      
