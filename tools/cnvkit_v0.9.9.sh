#!/bin/bash 

## Get tool ## ============================
# Run using CNVKit GitHub release V0.9.9
# Pull docker as a singularity container 

singularity pull cnvkit_0.9.9.sif docker://etal/cnvkit:0.9.9

## Run tool ## ============================

# Normals generated using cnvkit_v.0.9.9_normal.sh
# Patient IDs replaced in github repo 

singularity run -B /data/:/data/ /cnvkit_v2.0/cnvkit_0.9.9.sif  cnvkit.py batch \
 1-T.sort.bam  2-T.sort.bam 3-T.sort.bam 4-T.sort.bam 5-T.sort.bam \
6-T.sort.bam  7-T.sort.bam 8-T.sort.bam 9-T.sort.bam 10-T.sort.bam \
11-T.sort.bam 12-T.sort.bam 13-T.sort.bam 14-T.sort.bam 15-T.sort.bam \
     --normal normal/cnvkit_0.9.9._PoN.cnn \
    --targets  refs/RMH200Solid.v1.3.no.tx.cytobands.no.Y.bed \
    --fasta refs/ucsc.hg19.fasta \
    --access /refs/hg19.trf.bed \
    --output-dir /output/ \
    --diagram --scatter

