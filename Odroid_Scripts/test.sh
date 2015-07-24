#!/bin/bash

I="0"
while [[ "$I" -lt "17" ]]
do
    echo -e "${I}"
    sleep 1
    I=$((${I}+1))
done
echo -e "Finished..."
