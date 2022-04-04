library(conumee) #v1.26.0
library(minfi) # v1.38.0
library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19) #v0.6.0
library(tidyverse) #v1.3.1


## Set base directories
baseDir <- setwd("/microarray_data")

# Run to be processed
run_no = "219"

print(paste0("processing run number ",run_no))

# Get the targets for the array from the run sample sheet
targets <- read.csv(file.path(paste0("run_",run_no,"v2.0.csv")), stringsAsFactors = FALSE)

## Load array data using minfi ##
RGset <- read.metharray.exp(targets = targets)
#RGset <- read.metharray.exp(file.path(baseDir, run_no))

# Process it
MsetRG <- preprocessRaw(RGset)

# Load processed data into conumee
RGset_load <- CNV.load(MsetRG)

print("Samples loaded")

# Set controls ==========================================================

# Select all other patients in the run to be used as normals
controls <- pData(MsetRG)$Sample_Group == "normal"

print("Controls loaded")

# Select the annotation type to use, array is EPIC ==========================

anno <- CNV.create_anno(array_type = "EPIC")
# Use overlap when mixing EPIC and 450K array data
#anno <- CNV.create_anno(array_type = "overlap")

# Line below is to remove error which flags as some EPIC probes will have no values
anno@probes <- anno@probes[names(anno@probes) %in%
                             names(minfi::getLocations(IlluminaHumanMethylationEPICanno.ilm10b4.hg19::IlluminaHumanMethylationEPICanno.ilm10b4.hg19))]

print("Annotation type created & updated for EPIC")

# Run CNV calling =======================================================

# Run CNV calling on one sample, against the controls selected earlier
# Make the sample name column into a list

setwd(paste0("/microarray_data/conumee_output/",run_no))

# Sample IDs removed
rmh_samples <-c("8", "7")

# for loop to create segmentation fields and plots 
for (RMH_ID_single in rmh_samples) {
  
  print(paste0("Processing " , RMH_ID_single))

x <- CNV.fit(RGset_load[RMH_ID_single], RGset_load[controls], anno)

## Segment and plot ##
x <- CNV.bin(x) # analyse per bin
x <- CNV.detail(x) # detail
x <- CNV.segment(x) # segmentation

y <- CNV.segment(CNV.detail(CNV.bin(x)))

# Save ================================================================

CNV.write(y, file = paste0("seg_file_", RMH_ID_single  ,".seg"), what = "segments") # save as a segmentation file

CNV.write(x, file = paste0("bins_file_", RMH_ID_single  ,".igv"), what = "bins") # save as a bin file

CNV.write(x, file = paste0("detail_", RMH_ID_single  ,".txt"), what = "detail") # save as a detail  file

CNV.write(x, file = paste0("probes_file_", RMH_ID_single  ,".igv"), what = "probes") # save as a bin file

print(paste0(RMH_ID_single, "saved"))

}

print(paste0("All samples processed for run ",run_no))
