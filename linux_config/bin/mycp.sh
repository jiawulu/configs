#!/bin/bash

## sync.sh frompath destpath

from=$1
to=$2
fileName=$3

toName=${fileName/$from/$to};

parent_dir=`dirname $toName`

# make dir if nessary
if [ ! -d $parent_dir ] ; then
    mkdir -p $parent_dir
fi

if [ -d $fileName ] ; then
    continue
fi

if [[ ! -f $toName || $(diff $fileName $toName) ]]; then	
    \cp $fileName $toName;
    echo "copy file from $fileName to  $toName";
fi
