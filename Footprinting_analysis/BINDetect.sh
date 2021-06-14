#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 26-01-2021
#
################################# DESCRIPTION #################################
#
# This script runs TOBIAS BINDetect function for each replicate in each of the
# assessed sets of peaks. This function estimates TF binding events from
# previously calculated footprint scores and motif information.
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
# - txt and xlsx files containing the results from the total BINDetect run
# - PDF containing an overview of score-distributions
# - For each motif in --motifs, there will be a directory containing results 
#   from the scanning for this motif:
#   - txt and xlsx files containing an overview of all motif occurrences (TFBS)
#     in --peaks for the corresponding TF
#   - png containing the TF binding motif logo
#   - "beds" directory containing bedfiles for all sites as well as 
#     bound/unbound splits.
#
# For more detailed information about the obtained outputs see:
# https://github.com/loosolab/TOBIAS/wiki/BINDetect
#
################################# REQUIREMENTS ################################
#
# Specify the path to INPUT_SCORE. If you have previously run ScoreBigwig.sh,
# the path to footprint scores files should be the same as specified here.
#
# The output directories are specified in the for loops and should correspond
# to the tested peaksets and replicates.
#
################################# MAIN ########################################

OUTPUT_DIR='BINDetect_Mouse'

if ! [ -d $OUTPUT_DIR ]; then

  mkdir $OUTPUT_DIR
  
fi

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  if ! [ -d $OUTPUT_SUBDIR_1 ]; then

  mkdir $OUTPUT_SUBDIR_1
  
  fi
  
  # Input BED file containing the peak regions of interest
  PEAK_SET=$peakset'_peaks.bed'

  for replicate in Female_Rep_1 Female_Rep_2 Male_Rep_1 Male_Rep_2

  do
  
    OUTPUT_SUBDIR_2=$OUTPUT_SUBDIR_1/$replicate
  
    if ! [ -d $OUTPUT_SUBDIR_2 ]; then

      mkdir $OUTPUT_SUBDIR_2
    
    fi
      
      # Input signal bigwig with footprint scores. It should have been
      # calculated across the specified input "PEAK_SET"
      INPUT_SCORES=ScoreBigwig_Mouse/$peakset/$replicate/$replicate'_footprint.bw'
      
      # Input FASTA file containing the reference genome to which the 
      # sequencing reads were mapped
      GENOME=mm10_genome.fa
      
      # Input motifs in either PFM, JASPAR or MEME format to scan for binding
      # sites
      MOTIFS=Mouse_PFMs_CISBP.meme
      
      # Command to run TOBIAS BINDetect
      # --cores indicates the number of cores to use
      TOBIAS BINDetect --motifs $MOTIFS --signals $INPUT_SCORES --genome $GENOME --peaks $PEAK_SET --outdir $OUTPUT_SUBDIR_2 --cores 10
  done
  
done
