#!/bin/sh
#
# tmhost

PROG=`basename $0`
USAGE="Usage: $PROG [--help] [-l] [[-x hostname] ...] hostgroup command

EXAMPLES:
  $PROG \"GROUP=galaxyhost TYPE=online\" \"ls /\" 
"


cd `dirname $0`
BASE_HOME=$PWD
if [ -L $0 ] ; then
    FILE=`readlink $0`
    BASE_HOME=$BASE_HOME/`dirname $FILE`
    cd $BASE_HOME
fi

HOSTFILE=$BASE_HOME/hosts.conf

SSH=`which npsshc_board`
EXCLUDES=" "
LISTMODE=""

# -l option - list available hostgroups

while [ $# -gt 0 ]
do
    case "$1" in
      --help)
          echo "Usage: $PROG [ -x hostname ... ] hostgroup command"
          echo "       $PROG -l to list available hostgroups"
          echo "e.g."
          echo "        $PROG OS=Solaris uname -a"
          exit 1
          ;;
      -l) if [ $# -eq 1 ]
          then 
							echo "$PROG: Available hostgroups:"
          		cat $HOSTFILE
          		exit 2
					else
							LISTMODE="TRUE"
					fi
          ;;
      -x) if [ $# -gt 0 ]
          then
              shift
              EXCLUDES="${EXCLUDES}$1 "
          else
              echo "$PROG: missing argument to -x flag" 1>&2
              echo "$USAGE" 1>&2
              exit 1
          fi
          ;;
      -*) echo "$PROG: illegal flag \"$1\"" 1>&2
          echo "$USAGE" 1>&2
          exit 1
          ;;
      *)  break
          ;;
    esac
    shift
done

# Extract hostgroup argument
if [ $# -lt 2 -a "$LISTMODE" != "TRUE" ]
then
    echo "$PROG: insufficient arguments" 1>&2
    echo "$USAGE" 1>&2
    exit 1
fi


GROUP=$1
shift

# Go through list of servers for the given hostgroup

if [ "$GROUP" = "ALL" ]
then
    GROUP=""
fi

. $BASE_HOME/includes.hosts_funcs.sh

for host in `get_machines ${GROUP}`
do
    tty -s && printf "\r\n`tput smso` $host `tput rmso`"

    # Skip if excluded - otherwise do ssh command

    case "$EXCLUDES" in
    *" $host "*)
        echo " - skipped"
        continue
        ;;
    *)
				if [ "$LISTMODE" = "TRUE" ];then
					echo					
					continue				
				fi

				echo
        {
                # We need to filter out the display of /etc/issue from ssh
                # which comes on stderr.
                # The awk script is the easiest way of safely filtering it out
                $SSH $host "$*" 3>&2 2>&1 1>&3 \
                    |    awk '
/^\*\*/ {
                if (skip) {
                        print
                } else {
                        next
                }
        }
        {
                skip=1
                print
        }'
        } 3>&2 2>&1 1>&3
        3>&-
        ;;
    esac
done
exit 0

