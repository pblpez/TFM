#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 26-01-2021
#
################################# DESCRIPTION #################################
#
# This script runs TOBIAS PlotAggregate function for each replicate in each of
# the assessed sets of peaks. This function displays an aggregated view of
# footprint signals across regions. 
# 
# This code creates aggregated plots of footprint signals for bound TFBS by the
# selected acinar-expressed TFs. For detailed information about this function
# see: https://github.com/loosolab/TOBIAS/wiki/PlotAggregate
#
# The script is designed for the specific analysis performed in this project in
# which we have 2 female replicates and 2 male replicates and 4 different sets
# of peaks (ATAC-seq OCRs, H3K4me3-filtered OCRs, OCRs filtered by H3K27ac in
# promoters and OCRs filtered by H3K27ac in enhancers).
#
# The code can be adapted by changing the names specified in the for loops.
#
################################# REQUIREMENTS ################################
#
# "ATACorrect.sh" and "Acinar_expressed_bound_TF_selection.sh" should have been
# previously run.
#
# This script creates aggregated footprint signal views for all the TFs in
# INPUT_BOUND_TFBS. Speficy a file to create single views.
#
# The output directories are specified in the for loops and should correspond
# to the tested peak sets and replicates.
#
################################# MAIN ########################################

OUTPUT_DIR='PlotAggregate_Mouse'

if ! [ -d $OUTPUT_DIR ]; then

  mkdir $OUTPUT_DIR
  
fi

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  if ! [ -d $OUTPUT_SUBDIR_1 ]; then

  mkdir $OUTPUT_SUBDIR_1
  
  fi

  for replicate in Female_Rep_1 Female_Rep_2 Male_Rep_1 Male_Rep_2

  do
  
    OUTPUT_SUBDIR_2=$OUTPUT_SUBDIR_1/$replicate
    
    if ! [ -d $OUTPUT_SUBDIR_2 ]; then

      mkdir $OUTPUT_SUBDIR_2
    
    fi
    
    # Input corrected Tn5 cutsite signals
    INPUT_CORRECTED_SIGNAL=ATACorrect_Mouse/$peakset/$replicate/$replicate.trim.srt.nodup.no_chrM_MT_corrected.bw
    
    # Input BED files with bound TFBS
    INPUT_BOUND_TFBS=Selected_acinar_expressed_TFs/$peakset/$replicate/*
    
    for file in $INPUT_BOUND_TFBS
    
    do
    
      filename="${file##*/}"
           
    # Command to run TOBIAS PlotAggregate
    TOBIAS PlotAggregate --TFBS $file --signals $INPUT_CORRECTED_SIGNAL --output $OUTPUT_SUBDIR_2/$filename.png --plot_boundaries --share_y sites
    
    done
    
  done
  
done
