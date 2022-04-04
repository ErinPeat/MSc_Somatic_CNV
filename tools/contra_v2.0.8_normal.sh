#!/bin/bash


# Required modules on HPC ## ============================
module load bedtools/2.29.2
module load SAMtools/1.11
module load R/4.0.2

## Run tool ## ============================

# IDs removed from bams
# make PoN

python2.7 CONTRA.v2.0.8/baseline.py \
 --target efs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed \
 --files  normals/F001-T.sort.bam normals/F002-T.sort.bam normals/M003-T.sort.bam \
 normals/M004-T.sort.bam normals/F005-T.sort.bam normals/M006-T.sort.bam \
 normals/F007-T.sort.bam normals/F008-T.sort.bam normals/M009-T.sort.bam \
 --output /output/normal/ \
 --name CONTRA_V2.0.8_PoN



