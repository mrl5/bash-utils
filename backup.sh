#!/bin/bash
# Copyright 2018 mrl5
# Distributed under the terms of the GNU General Public License v3

STARTDIR=$(pwd -P)
BACKUPTARGET=$1
BACKUPARCHIVE=$(basename $BACKUPTARGET)-$(date +%Y%m%d).tar.bz2
BACKUPPRIMARYDIR=$2
BACKUPREDUNDANTDIR=$3
BACKUPFAILMSG="Operation failed. Aborting."

# todo
## if $2 and $3 not given then ...

echo "Creating backup..."
cd $BACKUPTARGET
tar --exclude=new-cls.git -jcvf $BACKUPPRIMARYDIR/$BACKUPARCHIVE *
if [ $? -eq 0 ]; then
    echo "Created" $BACKUPARCHIVE "in" $BACKUPPRIMARYDIR
    cd $BACKUPPRIMARYDIR
    echo "Copying backup to another directory..."
    cp -v $BACKUPARCHIVE $BACKUPREDUNDANTDIR
    if [ $? -eq 0 ]; then
        echo "Copied" $BACKUPARCHIVE to $BACKUPREDUNDANTDIR
    else
        echo $BACKUPFAILMSG
    fi
else
    echo $BACKUPFAILMSG
fi
cd $STARTDIR
