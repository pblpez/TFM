#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 21-01-2021
#
################################# DESCRIPTION #################################
#
# This scripts allows to divide the peaks from histone mark H3K27ac ChIP-seq 
# into two subsets, one for promoters and another one for enhancers.
#
# It also intersects the different peak sets from the different histone marks
# with the ATAC-seq consensus peaks to restrict the OCRs to specific functional
# regions. Each histone mark peak should overlap with at least 50% of the ATAC
# OCR peak to be considered as common peaks.
#
################################# REQUIREMENTS ################################
#
# Specify the path to each input peak file and to the desired output files.
# 
#
################################# MAIN ########################################

# Input files for H3K27ac peaks split.

H3K27AC_PEAKS=WT_H3K27ac_common_peaks.bed
TSS_REGIONS=plusminus_1kb_TSS.bed

# Output files for the H3K27ac peaks split.

H3K27AC_PROMOTER_PEAKS=H3K27ac_promoters.bed
H3K27AC_ENHANCER_PEAKS=H3K27ac_enhancers.bed

# Intersect the consensus peak file for H3K27ac mark with TSS +/- 1kb to obtain the promoter peak subset of H3K27ac.

bedtools intersect -a $H3K27AC_PEAKS -b $TSS_REGIONS -wa | uniq > $H3K27AC_PROMOTER_PEAKS

# Establish the uncommon peaks between H3K27ac and the H3K27ac promoter subset as the H3K27ac enhancer peak subset.

comm -23 <(sort $H3K27AC_PEAKS) <(sort $H3K27AC_PROMOTER_PEAKS) > $H3K27AC_ENHANCER_PEAKS


# Input files for ATAC-seq OCRs filtering.

ATAC_PEAKS=ATAC_Common_Peaks.bed
H3K4ME3_PEAKS=WT_H3K4me3_common_peaks.bed
H3K27ME3_PEAKS=WT_H3K27me3_common_peaks.bed

# Output files for ATAC-seq OCRs filtering.

ATAC_H3K4ME3_PEAKS=ATAC_peaks_overlapping_H3K4me3.bed
ATAC_H3K27AC_PROMOTER_PEAKS=ATAC_peaks_overlapping_H3K27ac_promoters.bed
ATAC_H3K27AC_ENHANCER_PEAKS=ATAC_peaks_overlapping_H3K27ac_enhancers.bed
ATAC_H3K27ME3_PEAKS=ATAC_peaks_overlapping_H3K27me3.bed

# Intersect the consensus ATAC-seq OCRs with different histone mark peak files to restrict the regions to specific functional elements.

bedtools intersect -a $ATAC_PEAKS -b $H3K4ME3_PEAKS -wa | uniq > $ATAC_H3K4ME3_PEAKS
bedtools intersect -a $ATAC_PEAKS -b $H3K27AC_PROMOTER_PEAKS -wa | uniq > $ATAC_H3K27AC_PROMOTER_PEAKS
bedtools intersect -a $ATAC_PEAKS -b $H3K27AC_ENHANCER_PEAKS -wa | uniq > $ATAC_H3K27AC_ENHANCER_PEAKS
bedtools intersect -a $ATAC_PEAKS -b $H3K27ME3_PEAKS -wa | uniq > $ATAC_H3K27ME3_PEAKS
