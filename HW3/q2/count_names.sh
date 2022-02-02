#! /bin/bash

FILE_NAME=$1
COUNT=0

while read -r CURRENT_LINE
do
    LINE=$(echo $CURRENT_LINE | cut -d " " -f1- | tr ',' ' ' | tr '|' ' ' | tr '\' ' '| tr '!' ' '| tr '$' ' ')
    LINE=$(echo $LINE | cut -d " " -f1-)
    for NAME in $LINE
    do
        NAME=$(echo $NAME | tr -d " \t\n\r")
        if [ ! -z "$NAME" ]
        then
            ((COUNT++))  
        fi    
    done
done < <(grep . "${FILE_NAME}")
echo "Count: $COUNT"
