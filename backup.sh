#!/bin/bash
# Copyright 2018 mrl5
# Distributed under the terms of the GNU General Public License v3

# Example 1: 'sh backup.sh /path/to/target' (creates backup.tar.bz2 in current directory)
# Example 2: 'sh backup.sh /path/to/target /path/to/backup/directory' (creates backup.tar.bz2 in given directory)

STARTDIR=$(pwd -P)
BACKUPTARGET=$1
BACKUPARCHIVE=$(basename $BACKUPTARGET)-$(date +%Y%m%d).tar.bz2
BACKUPFAILMSG="Operation failed. Aborting."

#if length of $2 is zero
if [ -z $2 ]; then
  BACKUPDIR=$STARTDIR
else
  BACKUPDIR=$2
fi

echo "Creating backup..."
cd $BACKUPTARGET
tar -jcvf $BACKUPDIR/$BACKUPARCHIVE *
#$? success flag of last operation (0 = success; other = fail)
if [ $? -eq 0 ]; then
  echo "Created" $BACKUPARCHIVE "in" $BACKUPDIR
else
  echo $BACKUPFAILMSG
fi
cd $STARTDIR
