#!/bin/bash

## Required modules on HPC ## ============================
module load SAMtools/1.11
perl -MCPAN -Mlocal::lib -e 'CPAN::install(Statistics::Distributions)'
module load gcc
module load boost
cpan -f Statistics::Normality

## Get tool ## ============================
# Using ConVaDING V1.2.1 

git clone https://github.com/molgenis/CoNVaDING.git 

## Run tool ## ============================

# Generate normalized count files for tumour #

perl CoNVaDING-1.2.1/CoNVaDING.pl -mode StartWithBam \
 -inputDir /bams_tumour \
 -controlsDir /normal  \
 -outputDir /output/tumour \
 -bed /refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed


# Selecting the most informative control samples #

perl CoNVaDING-1.2.1/CoNVaDING.pl -mode StartWithMatchScore  \
 -inputDir /tumour  \
 -controlsDir /output/normal  \
 -outputDir /output/best_match

# CNV Detection #

perl CoNVaDING-1.2.1/CoNVaDING.pl -mode StartWithBestScore   \
 -inputDir /output/best_match  \
 -controlsDir /output/normal  \
 -outputDir /output/cnv_calls

# Generate Target QC list #

perl /CoNVaDING-1.2.1/CoNVaDING.pl -mode GenerateTargetQcList \
 -inputDir output/normal  \
 -controlsDir output/normal  \
 -outputDir output/target_qc


# Create final list #

perl CoNVaDING-1.2.1/CoNVaDING.pl -mode CreateFinalList \
 -inputDir output/cnv_calls  \
 -targetQcList output/target_qc/targetQcList.txt  \
 -outputDir output/final_cnv_calls


