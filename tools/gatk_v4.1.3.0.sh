#!/bin/bash

## Required modules on HPC ## ============================
module load GATK/4.1.9.0
module load anaconda
module load java/jdk15.0.1

## Run tool ## ============================
# Sample IDs
list_of_samples=samples.txt

# Run using a custom cromwell_v0.1.conf to enable use of singularity instead of Docker in workflow
# Run GATK Somatic Pair CNV caller #

while IFS="" read line || [[ -n "$line" ]];
do
       sample=$(echo $line | cut -d " " -f1)

 java -Dconfig.file= /cromwell_v0.1.conf \
  -jar /cromwell-66.jar run \
  cnv_somatic_pair_workflow.wdl \
 -i gatk_v4.1.3.0_$sample.json

done < $list_of_samples


