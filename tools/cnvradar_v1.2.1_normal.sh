#!/bin/bash

## Get tool ## ============================
# Run using CNVRadar DockerHub image V1.2.1
# PoN from normal rois


## Run tool ## ============================
# Read in sample IDs and run one by one
# Make a roi file for each normal
list_of_samples=normal_samples.txt

while IFS="" read line || [[ -n "$line" ]];
do
        normal_sample=$(echo $line | cut -d " " -f1)


singularity run  -B /data/:/data cnvradar_v1.2.1.sif  \
Rscript /opt/CNVRadar/bam2roi.r \
 -b normals/$normal_sample.bam \
 -o/output/normal \
 -d refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.3.cols.bed -z


done < $list_of_samples

## Create control data set using normal samples ##

singularity run  -B /data/:/data /cnvradar_v1.2.1.sif \
Rscript /opt/CNVRadar/CNV_Radar_create_control.r \
 -d output/normal \
 -o cnvradar_v1.2.2_PoN \
 -p output/normal


