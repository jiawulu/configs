#!/bin/bash

## sync.sh frompath destpath

from=$1
to=$2
#echo $from

#find $from | grep -v ".svn" 
for fileName in $(find $from | grep -v ".svn" ) ; do

    mycp.sh $from $to $fileName

done
