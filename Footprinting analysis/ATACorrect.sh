#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 25-01-2021
#
################################# DESCRIPTION #################################
#
# This script runs TOBIAS ATACorrect function for each replicate in each of the
# assessed sets of peaks. This function corrects the Tn5 inherent cutting
# pattern bias.
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
# - Uncorrected cutsite signal
# - Raw bias score
# - Expected cutsite signal
# - Corrected cutsite signal
# - PDF file showing the observed Tn5 bias before and after correction
# - Pickle file containing the learned bias motif
#
# For further information regarding the outputs see:
# https://github.com/loosolab/TOBIAS/wiki/ATACorrect
#
# The corrected cutsite signal is the required output for downstream analysis.
#
################################# REQUIREMENTS ################################
#
# If the needed input files are located in the same directory and the script is
# run from that directory, as specified in
# https://github.com/PabloPerez5/TFM/edit/main/README.md, no modifications are
# required. In the opposite case, specify the path to each input file. 
#
# The output directories are specified in the for loops and should correspond
# to the tested peak sets and replicates.
# 
# The input files for the ATAC-seq reads should contain the name specified in
# the "replicate" for loop.
#
# The input files for the peak regions should contain the name specified in the
# "peakset" for loop.
#
################################# MAIN ########################################

OUTPUT_DIR='ATACorrect_Mouse'

if ! [ -d $OUTPUT_DIR ]; then

  mkdir $OUTPUT_DIR
  
fi

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  if ! [ -d $OUTPUT_SUBDIR_1 ]; then

  mkdir $OUTPUT_SUBDIR_1
  
  fi
  
  # Input BED file containing the peak regions of interest for subsequent
  # footprinting
  PEAK_SET=$peakset'_peaks.bed'

  for replicate in Female_Rep_1 Female_Rep_2 Male_Rep_1 Male_Rep_2

  do
  
    OUTPUT_SUBDIR_2=$OUTPUT_SUBDIR_1/$replicate
  
    if ! [ -d $OUTPUT_SUBDIR_2 ]; then

      mkdir $OUTPUT_SUBDIR_2
    
    fi
      
      # Input BAM file containing the mapped ATAC-seq reads
      # The associated bam.bai index should be in the same
      # directory (else it will be created)
      INPUT_READS=$replicate.trim.srt.nodup.no_chrM_MT.bam
      
      # Input FASTA file containing the reference genome to which the 
      # sequencing reads were mapped
      GENOME=mm10_genome.fa
      
      # Input BED file containing blacklisted regions in the reference genome
      BLACKLIST=mm10.blacklist.bed
      
      # Command to run TOBIAS ATACorrect
      # --cores indicates the number of cores to use
      TOBIAS ATACorrect --bam $INPUT_READS --genome $GENOME --peaks $PEAK_SET --blacklist $BLACKLIST --outdir $OUTPUT_SUBDIR_2 --cores 10
  
  done
  
done
