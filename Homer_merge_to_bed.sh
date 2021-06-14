#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 10-11-2020
#
################################# DESCRIPTION #################################
#
# Merge two (or more) peak files with HOMER software to obtain a consensus peak
# file containing the overlapping peak positions between the original files.
# The output peak positions for overlaps comprise a broader region containing
# both overlapping original peaks.
#
# Select the lines corresponding to the merged peaks in the output file from 
# HOMER and transform them into bed format by deleting the header and keeping
# "chr" and "start-end" columns.
#
################################# REQUIREMENTS ################################
#
# Specify the path to each input peak file and to the desired output file.
# 
#
################################# MAIN ########################################

# In this script two input files are used, but more can be added.

INPUT_PEAKS_1=Female_rep1_vs_rep2.idr0.05.bfilt.narrowPeak
INPUT_PEAKS_2=Male_rep1_vs_rep2.idr0.05.bfilt.narrowPeak
OUT_FILE=ATAC_Common_Peaks.bed

# Merge the input peak file with HOMER.

mergePeaks -d given $INPUT_PEAKS_1 $INPUT_PEAKS_2 > tmp1.txt

# Select the lines containing merged peaks and transform them into bed format.

grep "|" tmp1.txt | tail -n +2 | cut -f 2-4 > $OUT_FILE

# Remove temporary files.

rm tmp1.txt


