#!/bin/bash 

## Required modules on HPC ## ============================
module load SAMtools/1.11
module load bedtools/2.29.2

## Get tool ## ============================
## Pull docker hub file as singularity container (.sif) ## 

singularity pull adtex_v2.0.sif docker://jeltje/adtex:2.0

singularity pull cnvtogenes_v2.0.sif docker://jeltje/cnvtogenes:2.0

## Run tool ## ============================

# Read in sample IDs and run one by one
list_of_samples=samples.txt

while IFS="" read line || [[ -n "$line" ]];
do
        sample=$(echo $line | cut -d " " -f1)

## Make the DoC files for ADTEx input ##

coverageBed -b bams_tumour/$sample-T.sort.bam  \
 -a refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed -d > \
bams_tumour/DoC_file/$sample-T_no_y.file

## Run ADTEx v2.0 ##

singularity run -B /data/:/data/ adtex_v2.0.sif \
 --normal /normals/create_PoN_DoC/PoN_large_bam_10_samples.file \
 --tumor /validation/bams_tumour/DoC_file/$sample-T_no_y.file \
 --sampleid $sample-T \
 --targetbed /refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed \
 --out /validation/adtex_v2.0/output \
 --centromeres /refs/centromeres.bed

done < $list_of_samples

## Run cnvtogenes ##
# Get the output of ADTEx on a per gene level
singularity run -B /data/:/data/ /cnvtogenes_2.0.sif \
 --cnvdir /adtex_v2.0/output \
 --genefile refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed > output/per_gene.table







