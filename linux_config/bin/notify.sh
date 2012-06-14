#!/bin/bash

#inotifywait -mrq -e modify,delete,create,moved_to --format %w%f www  | while read file 
inotifywait -mrq -e create,move,delete,modify $1 | while read D E F
do
    echo "--------------"
    echo $D
done



