#!/bin/bash            

## Required modules on HPC ## ============================
module load anaconda
source activate r-essentials4.0

## Run script ## ============================
Rscript /microarray_data/conumee_v1.26.0.R
