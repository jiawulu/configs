#!/bin/bash

## sync.sh frompath destpath

from=$1
to=$2
#echo $from

#find $from | grep -v ".svn" 
for fileName in $(find $from | grep -v ".svn" ) ; do
	toName=${fileName/$from/$to};
	#if need to create a directory

	[ -d $fileName ] && [ -d $toName ] && continue;

	if [[ -d $fileName  && ! -d $toName ]]; then
		echo "mkdir  $toName ";
		mkdir -p $toName;
		continue;
	fi

	if [[ -f $fileName && ! -f $toName ]]; then
	   echo "copy $fromName to $toName";
	   cp $fileName $toName;
	   continue;
	fi

	if [[ $(diff $fileName $toName) ]]; then	
		\cp $fileName $toName;
		echo "copy file from $fileName to  $toName";
		continue;
	fi
done
