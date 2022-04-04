#!/bin/bash

# Run using CNVKit GitHub release V0.9.9
# Create PoN (Only needs to be done once per library kit/bed file)
# Produce target & antitarget coverage for each normal

## Run tool ## ============================

# Read in sample IDs and run one by one
list_of_samples=normal_samples.txt

while IFS="" read line || [[ -n "$line" ]];
do
        normal_sample=$(echo $line | cut -d " " -f1)

singularity run -B /data/:/data/ cnvkit_0.9.9.sif cnvkit.py coverage \
 /normals/$ normal_sample.bam \
 /refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed

done < $list_of_samples

# Make a Panel of Normals
singularity run -B /data/:/data/ cnvkit_0.9.9.sif cnvkit.py reference \
 output/normal/ \
 --fasta /refs/hg19.fa \
 --output normal/cnvkit_0.9.9._PoN.cnn 


