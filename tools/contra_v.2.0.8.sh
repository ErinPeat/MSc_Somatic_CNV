#!/bin/bash

## Required modules on HPC ## ============================
module load bedtools/2.29.2
module load SAMtools/1.11
module load R/4.0.2


## Get tool ## ============================
# Code download from https://sourceforge.net/projects/contra-cnv/files/
# v2.0.8 used

## Run tool ## ============================

## Run cnv pipeline with one sample ##

# txt file with sample IDs to import
list_of_samples=samples.txt

# PoN made using contra_v2.0.8_normal.sh

while IFS="" read line || [[ -n "$line" ]];
do
        sample=$(echo $line | cut -d " " -f1)

   python2.7 CONTRA.v2.0.8/contra.py \
   --target refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.sorted.bed \
  --test bams_tumour/$sample-T.sort.bam  \
   --control  normal/CONTRA_V2.0.8_PoN.pooled2_TRIM0.2.txt \
   --minExon=100 --maxRegionSize=100 --targetRegionSize=75 --removeDups \
   --sampleName $sample \
   --bed \
   --o output/tumour/$sample/

done < $list_of_samples

## Run WGCNV single pipeline ## 

list_of_samples=samples.txt
while IFS="" read line || [[ -n "$line" ]];
do

        sample=$(echo $line | cut -d " " -f1)

 python2.7 /CONTRA.v2.0.8/WGCNV-SINGLE/wgcnv_noBAF.py \
 output/tumour/$sample/ \
 human \
 output/tumour/$sample/wgcnv/ \
 $sample

done < $list_of_samples

## Run null distribution estimation pipeline ##

python2.7 CONTRA.v2.0.8/NullDistEstimation/nde_wrapper.py \
 ContraOut_list.txt \
 /output/tumour/nde/ \
/refs/RMH200Solid.v1.3.no.tx.cytobands.bed \
 T T

