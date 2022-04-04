#!/bin/bash

# Get tool ## ============================
## Pull docker hub file as singularity container (.sif) ## 
# Run using CNVRadar DockerHub image V1.2.1

singularity pull cnvradar_v1.2.1.sif docker://eagenomics/cnvradar:v1.2.1

## Run tool ## ============================

## Create tumour ROIs ##

# Run once for each sample ID 
list_of_samples=samples.txt

while IFS="" read line || [[ -n "$line" ]];
do

     sample=$(echo $line | cut -d " " -f1)

 singularity run  -B /data/:/data cnvradar_v1.2.1.sif \
   Rscript /opt/CNVRadar/bam2roi.r \
  -b bams_tumour/$sample-T.sort.bam  \
  -o output/tumour \
  -d refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.3.cols.bed  -z

done < $list_of_samples

## Rename files ##

cd output/tumour/
for i in *; do mv "$i" cnvradar_v1.2.1_"$i"; done


## Annotate VCFS with common SNPS ##
# Run once for each sample ID 
list_of_samples=samples.txt

while IFS="" read line || [[ -n "$line" ]];
do

       sample=$(echo $line | cut -d " " -f1)

 singularity run  -B /data/:/data cnvradar_v1.2.1.sif \
  java -jar software/snpEff/SnpSift.jar \
  annotate refs/All_20180423.vcf \
 vcf_tumour/1.$sample-T.vardict.filtered.vcf  > output/tumour/cnvradar_v1.2.1_$sample-T_annotated.vardict.filtered.vcf

done < $list_of_samples

## Run main CNVRadar script ##
# PoN made using cnvradar_v1.2.1_normal.sh
# As the tool is made for WES, an altered version of cnvradar.R is used here 
# cnvradar_lower_knots.R is the altered version


list_of_samples=samples.txt

while IFS="" read line || [[ -n "$line" ]];
do

        sample=$(echo $line | cut -d " " -f1)

 singularity run  -B /data/:/data /cnvradar_v1.2.1.sif \
 Rscript cnvradar_lower_knots.R \
  -c cnvradar_v1.2.2_PoN.RData \
  -r  output/tumour/cnvradar_v2.0_$sample-T.sort_roiSummary.txt \
  -v  output/tumour/cnvradar_v2.0_$sample-T_annotated.vardict.filtered.vcf \
  -p  output/final_call

done < $list_of_samples



