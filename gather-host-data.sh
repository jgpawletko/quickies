#!/bin/bash
#------------------------------------------------------------------------------
# Time-stamp: <2014-06-13 23:44:27 pawletko>
#
# This script gathers information on a host and generates text files containing
# the results.  This can be useful during host migration to confirm that the
# migrated host in the new environment has the same attributes as in the old
# environment..
#
# This script should be run in a writable directory.
# The user needs sudo privileges for some commands.
#
# Input : none
# Output: a timestamped directory containing various text files
# 
#------------------------------------------------------------------------------
case `uname` in
    Linux)
    ;;

    *)
    echo "ERROR: script is for Linux only"
    exit 1
    ;;
esac

hname=`hostname`
hdate=`date "+%Y%m%dT%H%M%S"`
prefix='host-data'

dirname="${prefix}-${hname}-${hdate}"

mkdir $dirname
pushd $dirname > /dev/null


# Even-index elements: commands to execute
# Odd-index  elements: target file names
a[0]='for user in $(cut -f1 -d: /etc/passwd); do echo $user; sudo crontab -u $user -l; done'
a[1]='crontab-list.txt'
a[2]='sudo find /etc/cron.*'
a[3]='etc-cron-list.txt'
a[4]='sudo ps -auxf'
a[5]='ps-list.txt'
a[6]='mount -l | sort'
a[7]='fs-mounts-list.txt'
a[8]='chkconfig'
a[9]='chkconfig-list.txt'


i=0
while [[ $i -lt 10 ]]
do
    cmd=${a[$i]}
    ((i = i + 1))
    target=${a[$i]}
    ((i = i + 1))

    echo "# $hname $hdate $target" > $target
    echo "#----------------------------------------" >> $target
    eval $cmd | tee -a $target
done

exit 0

