#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 25-01-2021
#
################################# DESCRIPTION #################################
#
# This script runs TOBIAS ScoreBigwig function for each replicate in each of 
# the assessed sets of peaks. This function calculates footprint scores from
# corrected cutsites across accessible regions.
#
# More information about this tool can be found in:
# https://github.com/loosolab/TOBIAS/wiki/ScoreBigwig
#
# The script is designed for the specific analysis performed in this project in
# which we have 2 female replicates and 2 male replicates and 4 different sets
# of peaks (ATAC-seq OCRs, H3K4me3-filtered OCRs, OCRs filtered by H3K27ac in
# promoters and OCRs filtered by H3K27ac in enhancers).
#
# The code can be adapted by changing the names specified in the for loops. 
#
################################# OUTPUT ######################################
#
# Bigwig file containing calculated scores. 
# Positions with no score assigned can be interpreted as 0.
#
################################# REQUIREMENTS ################################
#
# Specify the path to INPUT_SIGNAL. If you have previously run ATACorrect.sh,
# the corrected cutsite signal path should be the same as specified here.
# 
# The output directories are specified in the for loops and should correspond
# to the tested peaksets and replicates.
#
#
################################# MAIN ########################################

OUTPUT_DIR='ScoreBigwig_Mouse'

if ! [ -d $OUTPUT_DIR ]; then

  mkdir $OUTPUT_DIR
  
fi

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  if ! [ -d $OUTPUT_SUBDIR_1 ]; then

  mkdir $OUTPUT_SUBDIR_1
  
  fi
  
  # Input BED file containing the peak regions of interest in which to compute
  # footprint calculation
  PEAK_SET=$peakset'_peaks.bed'

  for replicate in Female_Rep_1 Female_Rep_2 Male_Rep_1 Male_Rep_2

  do
  
    OUTPUT_SUBDIR_2=$OUTPUT_SUBDIR_1/$replicate
  
    if ! [ -d $OUTPUT_SUBDIR_2 ]; then

      mkdir $OUTPUT_SUBDIR_2
    
    fi
      
      # Input bigwig signal containing corrected cutsites per basepair
      INPUT_SIGNAL=ATACorrect_Mouse/$peakset/$replicate/$replicate.trim.srt.nodup.no_chrM_MT_corrected.bw
      
      # Output bigwig file to save the calculated footprint scores
      OUTPUT_FILE=$OUTPUT_SUBDIR_2/$replicate'_footprint.bw'
      
      # Command to run TOBIAS ScoreBigwig. --cores indicates the number of cores to use
      # --score "footprint" option is established as default
      TOBIAS ScoreBigwig --signal $INPUT_SIGNAL --regions $PEAK_SET --output $OUTPUT_FILE --cores 10
  
  done
  
done
