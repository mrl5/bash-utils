#!/bin/bash
# Copyright 2018 mrl5
# Distributed under the terms of the GNU General Public License v3

# This script creates backup of content of given directory
# Example 1: 'sh backup.sh /path/to/target/directory'
#  creates "directory-YYMMDD.tar.bz2" archive in current directory
# Example 2: 'sh backup.sh /path/to/target/directory /path/to/backup/directory'
#  creates "directory-YYMMDD.tar.bz2" archive in given backup directory

STARTDIR=$(pwd -P)
BACKUPTARGET=$1
BACKUPFAILMSG="Operation failed. Aborting."

#if directory starts with only one "." ...
if [[ $(basename $BACKUPTARGET) =~ ^\.[^.]. ]]; then
  PARTIALNAME=$(basename $BACKUPTARGET | cut -d'.' -f2-)
else
  PARTIALNAME=$(basename $BACKUPTARGET)
fi

BACKUPARCHIVE=$PARTIALNAME-$(date +%Y%m%d).tar.bz2

#if length of $2 is zero
if [ -z $2 ]; then
  BACKUPDIR=$STARTDIR
else
  BACKUPDIR=$2
fi

echo "Creating backup..."
cd $BACKUPTARGET
tar -jcvf $BACKUPDIR/$BACKUPARCHIVE .
#$? success flag of last operation (0 = success; other = fail)
if [ $? -eq 0 ]; then
  echo "Created" $BACKUPARCHIVE "in" $BACKUPDIR
else
  echo $BACKUPFAILMSG
fi
cd $STARTDIR
