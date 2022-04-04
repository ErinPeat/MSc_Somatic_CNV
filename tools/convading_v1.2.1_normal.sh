#!/bin/bash

## Required modules on HPC ## ============================
module load SAMtools/1.11
perl -MCPAN -Mlocal::lib -e 'CPAN::install(Statistics::Distributions)'
module load gcc
module load boost
cpan -f Statistics::Normality


## Run tool ## ============================

# Generate normalized count files for normals #

perl CoNVaDING-1.2.1/CoNVaDING.pl -mode StartWithBam \
 -inputDir normals/normals_paeds_germ \
 -useSampleAsControl \
 -controlsDir normals/normals_paeds_germ  \
 -outputDir output/normal \
 -bed refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed
