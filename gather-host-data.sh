#!/bin/bash
#------------------------------------------------------------------------------
# Time-stamp: <2014-06-13 23:44:27 pawletko>
#
# This script gathers information on a host and generates text files containing
# the results.  
#
# This script should be run in a writable directory.
# The user needs sudo privileges for some commands.
#
#------------------------------------------------------------------------------

hname=`hostname`
hdate=`"+%Y%m%dT%H%M%S"`
prefix='host-data'

dirname="${prefix}-${hname}-${hdate}"

mkdir $dirname
pushd $dirname > /dev/null


# Even indices are commands to execute, odd indices are the target file names
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

