#!/bin/bash

# Goal
# sample    unit    lib platform    fq1 fq2

# We split the files to get the info needed and grep from the metadata file.

echo -e "sample\tunit\tlib\tplatform\tfq1\tfq2" > doc/units.tsv

# Loop through each sample ID (skip header with tail -n +2)
for id in $(tail -n +2 doc/test_samples_NGI_id.txt); do

    # Find fastq files only for this sample
    FSTQ=$(find ../../RawData/lcNGS_2025/files/P36454/$id/ -name "*.fastq.gz" -type f)

    for file in $(echo $FSTQ | tr " " "\n" | grep "_R1_"); do
        UNIT=$(echo $file | cut -f 7 -d "/")
        LANE=$(echo $file | cut -f 9 -d "_" | sed s/L00//g)
        UNIT_FIN=${UNIT}.$LANE
        R2=$(echo $file | tr " " "\n" | sed s/_R1_/_R2_/g)
        LIB=$(awk -F'\t' -v unit="$UNIT" '$12 == unit {print $14}' doc/MetaData_bioinfo.tsv | tr -d ' ')
        SAMP=$(awk -F'\t' -v unit="$UNIT" '$12 == unit {print $11}' doc/MetaData_bioinfo.tsv | tr -d ' ')
        echo -e "$SAMP\t$UNIT_FIN\t$LIB\tILLUMINA\t$file\t$R2" >> doc/units.tsv
    done
done
