#!/bin/sh

PROG=`basename $0`
USAGE="Usage: $PROG [-h|?] [-u username] [-n hostindex(3,4,5)] [-c ssh|scp|del|fdel] [-f filename]"

SSH=`which ssh`
SCP=`which scp`
USER=`whoami`
HOSTINDEX=3
CMD="ssh"

while getopts u:n:c:f:h opt
	do
		case $opt in
					u) USER=$OPTARG;;
					n) HOSTINDEX=$OPTARG;;
					c) CMD=$OPTARG;;
					f) FILE=$OPTARG;;
			 \?|h) echo $USAGE; exit 1;;
		esac
  done

case "$HOSTINDEX" in
				3|4|5);;
						*) HOSTINDEX=3;;
esac

case "$CMD" in
				scp)
					if [ -n "$FILE" ] ; then
						$SCP $FILE $USER@login1.cm$HOSTINDEX.taobao.org:~/
					else
						echo $USAGE; exit 2
					fi
					;;
				del)
					if [ -n "$FILE" ] ; then
						$SSH $USER@login1.cm$HOSTINDEX.taobao.org "rm -ri $FILE"
					else
						echo $USAGE; exit 3
					fi
					;;
				fdel)
					if [ -n "$FILE" ] ; then
						$SSH $USER@login1.cm$HOSTINDEX.taobao.org "rm -rf $FILE"
					else
						echo $USAGE; exit 3
					fi
					;;
				ssh|*) 
					$SSH $USER@login1.cm$HOSTINDEX.taobao.org
esac
