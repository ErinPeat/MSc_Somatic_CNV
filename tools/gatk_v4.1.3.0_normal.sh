#!/bin/bash

## Required modules on HPC ## ============================
module load GATK/4.1.9.0
module load anaconda
module load java/jdk15.0.1

## Run tool ## ============================

# Make PoN # 
# custom cromwell_v0.1.conf 

java -Dconfig.file=cromwell_v0.1.conf \
  -jar cromwell-66.jar  run \
 cnv_somatic_panel_workflow.wdl \
 -i gatk_v4.1.3.0_normal

