#!/bin/bash
# Copyright 2018 mrl5
# Distributed under the terms of the GNU General Public License v3

# Creates new pdf from part of another pdf
#
# $1: input file
# $2: output file
# $3: first range
# $4: second range
# $n-2: nth range
#
# Example: 'sh split-pdf.sh /path/to/input.pdf /path/to/output.pdf 1-1 6-9 18-21'
#  creates output.pdf from input.pdf pages: 1, 6, 7, 8, 9, 18, 19, 20, 21

INDEX=1
TMPNAME="temp-pdf-snapshot"
TMPDIR="/tmp/temp-pdf-snapshots"

# get directory of /path/to/outputfile.pdf file
OUTPUTDIR=${2%/*}

if [ $OUTPUTDIR == $2 ]
then
    OUTPUTDIR="."
fi

mkdir $TMPDIR

for RANGE in ${@:3}
do
    START=$(echo $RANGE | cut -d'-' -f1)
    END=$(echo $RANGE | cut -d'-' -f2)
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$START -dLastPage=$END -sOutputFile=$TMPDIR/$TMPNAME-$INDEX.pdf $1
    ((INDEX++))
done

gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$2 -dBATCH $TMPDIR/$TMPNAME*.pdf
rm -rf $TMPDIR
