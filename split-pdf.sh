#!/bin/bash
# Copyright 2018 Jakub Kołodziejczak
# Distributed under the terms of the GNU General Public License v3

# $1: input file
# $2: output file
# $3: first range
# $4: second range
# $n-2: nth range

index=1
tmpname="temp-pdf-snapshot"
tmpdir="/tmp/temp-pdf-snapshots"

### get output dir from /path/to/outputfile.pdf
OUTPUTDIR=${2%/*}

if [ $OUTPUTDIR == $2 ]
then
    OUTPUTDIR="."
fi

mkdir $tmpdir

for RANGE in ${@:3}
do
    START=$(echo $RANGE | cut -d'-' -f1)
    END=$(echo $RANGE | cut -d'-' -f2)
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$START -dLastPage=$END -sOutputFile=$tmpdir/$tmpname-$index.pdf $1
    ((index++))
done
gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$2 -dBATCH $tmpdir/$tmpname*.pdf
rm -rf $tmpdir
