#!/bin/sh
#
# FILE:         includes.hosts_funcs.sh
#
#
# DESCRIPTION:  provides parsing routines
#
#               To use just include in your favourite Bourne, K shell or Bash
#               script
#
#                       . /opt/scripts/includes.sh
#
#               This will use a default configuration file of
#               /opt/etc/hosts.conf
#
################################################################################

# Do not enable the following line, if ths script is to be included
# in another script.
#set -u                 # abort on undefined variables

################################################################################

#DEBUG=false

_HOSTS_CONF=./hosts.conf

# unfortunately the following only works with BASH shell
#_HOSTS_CONF=${@-/opt/scripts/hosts.conf}

################################################################################
# syntax for hosts.conf file is:
#
# <machine-name>        [<keyword>=<values> ...]
#
# where
#       <machine-name> = [A-Z][A-Z1-9-]* | DEFAULT
#
#               This is normally a hostname as returned by "uname -n"
#               The special reserved name "DEFAULT" signifies a set of
#               keyword/value pairs which apply to all machines
#
#       <keyword>      = [A-Z][A-Z1-9_]* | HOST
#
#               keywords must be upper case, the only reserved keyword is
#               HOST, but other recommended keywords might be
#
#                       CLASS   to describe class of machine,
#                               e.g. Production, Test, dev, etc
#                       OS      for operating system
#                               e.g. Solaris_9, Solaris_8, AIX_4.3, HP-UX_10
#                       APPS    for applications installed
#                               e.g. Oracle, Netbackup
#                       ROLE    Main functtions provided by machine,
#                               e.g. DB, FW, INTRA, LDAP
#
#       <values>       = value | value "," value
#       <value>        = string | quoted-string
#       <string>       = any non-space character (treated as case-insensitive)
#       <quoted string>= " any character "
#
################################################################################


################################################################################
# Function:     get_machines
# Description:  return list of machine which match defined arguments
#
#   `get_machines`                      - will return all machines
#   `get_machines  CLASS=PROD`          - will return all production machines
#   `get_machines  OS=Solaris8`         - will return all Solaris8 machines
#   `get_machines  OS=Solaris8 APP=DB`  - will return all Solaris 8 Database
#                                         servers
# Lazy arguments are allowed (though not recommended)
#   `get_machines  PROD`                - will return any machine who has a
#                                         keyword value of "PROD"
#
# NOTE: if multiple values are specified they are all AND'd together
#
# TODO:
# 1. Support exclusions
#    e.g. `get_machines OS=Solaris8 - buzzard`
#         `get_machines OS=Solaris8 - CLASS=TEST`
# 2. Support OR'ing
# 3. Support wilcarded values
#    e.g. `get_machines OS=Solaris*`

get_machines() {

        list_hosts_config() {
                # first sed removes fully commented out lines
                # second sed removes all trailing unescaped comments without trailing backslash
                # third sed removes trailing comment retaining trailing backslash
                # fourth sed removes trailing blanks from lines
                # while loop folds backslashed lines into one line
                # final sed removes any remaining blank lines
                SP='[    ]'     # WARNING - This varable contains a tab and a space
                cat ${_HOSTS_CONF} \
                    |   sed -e '/^#/d' \
                            -e 's/\([^\\]\)#.*[^\\]$/\1/' \
                            -e "s/${SP}*#.*\\$/\\\\/" \
                            -e "s/${SP}*$//" \
                    |   while read line
                        do
                                echo "$line"
                        done \
                    |   sed -e '/^$/d'

        } # lists_hosts_config
        #$DEBUG && echo "get_machines($@) \$#=$#"
        if [ $# = 0 ]
        then : no arguments given just return whole file
                list_hosts_config \
                    |   while read host keyvals
                        do
                                if [ "$host" != "DEFAULT" ]
                                then
                                        echo "$host"
                                fi
                        done
        else : patterns given as arguments to match
                newargs=
                focus=
                PATTERNS=0
                for args
                do : args="$args"
                        case "$args" in
                                HOST=*)
                                        focus=`IFS="="; set -- $args; echo $2`
                                        #focus=`IFS=","; set -- $focus; echo $*`
                                        #$DEBUG && echo "Focus on hosts: $focus"
                                        ;;
                                *) : default
                                        newargs="$newargs $args"
                                        PATTERNS=`expr $PATTERNS + 1`
                                        ;;
                        esac
                done

                DEFAULT_KEYVALS=
                list_hosts_config \
                    |   while read host keyvals
                        do : host=\"$host\", keyvals=\"$keyvals\"
                                MATCHES=0
                                if [ $host = "DEFAULT" ]
                                then : can\'t handle default
                                        DEFAULT_KEYVALS=$keyvals
                                elif [ "$focus" = "" -o "$focus" = "$host" ]
                                then
                                        #$DEBUG && echo "checking $host against $PATTERNS pattern(s)"

                                        # go through all the default settings inserting
                                                                                # any non-clashing keys into candidate lists
                                        for defkeyval in $DEFAULT_KEYVALS
                                        do : defkeyval=$defkeyval
                                                defkey=`IFS="="; set -- $defkeyval; echo $1`
                                                clash=false
                                                for keyval in $keyvals
                                                do : keyval=$keyval
                                                        key=`IFS="="; set -- $keyval; echo $1`
                                                        if [ "$key" = "$defkey" ]
                                                        then
                                                                clash=true
                                                        fi
                                                done
                                                if $clash
                                                then : ignore clashes
                                                else : use
                                                        keyvals="$keyvals $defkeyval"
                                                fi
                                        done

                                        for keyval in $keyvals
                                        do : keyval=$keyval
                                                case "$keyval" in
                                                        *=)
                                                                key=`IFS="="; set -- $keyval; echo $1`
                                                                vals=""
                                                                ;;
                                                        *=*)
                                                                key=`IFS="="; set -- $keyval; echo $1`
                                                                vals=`IFS="="; set -- $keyval; echo $2 | tr a-z A-Z`
                                                                ;;
                                                        *)
                                                                echo "illegal syntax detected against entry for $host" 1>&2
                                                                exit 1
                                                                ;;
                                                esac
                                                for val in `IFS=","; set -- "$vals"; echo $*`
                                                do : val=$val
                                                        for args in $newargs
                                                        do : args=\"$args\"
                                                                #$DEBUG && echo "  matching "args=$args" against $key=$val"
                                                                case "$args" in
                                                                        *=)
                                                                                KEYWORD=`IFS="="; set -- $args; echo $1`
                                                                                VALUE=""
                                                                                ;;
                                                                        *=*)
                                                                                KEYWORD=`IFS="="; set -- $args; echo $1`
                                                               VALUE=`IFS="="; set -- $args; echo $2 | tr a-z A-Z`
                                                                                ;;
                                                                        *)
                                                                                KEYWORD='*'
                                                                                VALUE=`echo $args | tr a-z A-Z`
                                                                                ;;
                                                                esac

                                                                if [ "$KEYWORD" = $key -o "$KEYWORD" = "*" ]
                                                                then
                                                                        if [ $VALUE = "$val" ]
                                                                        then : true
                                                                                #$DEBUG && echo "  * match"
                                                                                MATCHES=`expr $MATCHES + 1`
                                                                                #echo "  $host"
                                                                                #return
                                                                        fi
                                                                fi
                                                        done
                                                done
                                        done
                                        if [ $MATCHES -eq $PATTERNS ]
                                        then
                                                echo "$host"
                                        fi
                                fi
                        done
        fi
} # get_machines

################################################################################
# Function:     test_machine
# Description:  will return true or false  if machine speficed matches given
#               criteria
#
#   `test_machine  $MACHINE`           - will return true if $MACHINE is defined
#   `test_machine  $MACHINE ROLE=WEB`  - will return true if $MACHINE has a role
#                                        including "WEB"

test_machine() {

        MACHINE=$1
        shift
        [ "`get_machines HOST=$MACHINE "$@"`" = "$MACHINE" ] && true || false

} # test_machine

################################################################################

