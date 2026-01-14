#!/bin/bash

FSTQ=$(find ../../RawData/lcNGS_2025/files/P36454/ -name "*.fastq.gz" -type f)


# Goal
# sample	unit	lib	platform	fq1	fq2

echo -e "sample\tunit\tlib\tplatform\tfq1\tfq2" > doc/units.tsv

for file in $(echo $FSTQ | tr " " "\n" | grep "_R1_"); do
    
    UNIT=$(echo $file | cut -f 7 -d "/")
    LANE=$(echo $file | cut -f 9 -d "_" | sed s/L00//g)
    UNIT_FIN=${UNIT}.$LANE
    R2=$(echo $file | tr " " "\n" | sed s/_R1_/_R2_/g)
    LIB=$(cat doc/MetaData_bioinfo.tsv | grep $UNIT | cut -f 14)
    SAMP=$(cat doc/MetaData_bioinfo.tsv | grep $UNIT | cut -f 11)

    echo -e "$SAMP\t$UNIT_FIN\t$LIB\tILLUMINA\t$file\t$R2" >> doc/units.tsv
done