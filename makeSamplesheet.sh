#!/bin/bash

# get into folder with input fastq files in upper directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Changing to input directory: $SCRIPT_DIR/../input"
#OUTPUT_DIR="$SCRIPT_DIR/../input"
cd "$SCRIPT_DIR/../input" || exit 1

shopt -s nullglob

# Rename files to remove leading AMPXXX_ if present
amp_files=(AMP[0-9][0-9][0-9]_*.fastq.gz)
for f in "${amp_files[@]}"; do
    mv -- "$f" "${f#AMP[0-9][0-9][0-9]_}"
done

# Create samplesheet.csv
{
    echo "run,name"
    for f in *_R1.fastq.gz; do
        base=${f%_R1.fastq.gz}
        run=${base##*_}
        name=${base%_*}
        echo "$run,$name"
    done
} > samplesheet.csv