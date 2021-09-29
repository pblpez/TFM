#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 28-01-2021
#
################################# DESCRIPTION #################################
#
# The origin file needed to run TOBIAS CreateNetwork consists on a list of gene
# names in the first column and gene IDs in the second column. The network will
# be built based on the input TFBS and this origin file. The target genes and
# input TFs should be present in the origin file to be represented in the
# network.
#
# This script creates two different origin files. One consisting on the
# selected acinar-expressed TFs to model their interactions in a TF-TF network.
# Another one including TFs, but also all their target genes.
# 
#
# The script is designed for the specific analysis performed in this project in
# which we have 4 different sets of peaks (ATAC-seq OCRs, H3K4me3-filtered OCRs,
# OCRs filtered by H3K27ac in promoters and OCRs filtered by H3K27ac in
# enhancers).
#
# The code can be adapted by changing the names specified in the for loops. 
#
################################# REQUIREMENTS ################################
#
# This script should be run right after having executed correctly 
# "TFBS_footprint_format.sh".
#
################################# MAIN ########################################

# File with the names of the selected acinar-expressed TFs (1 name per row)
SELECTED_TF=Acinar_expressed_TF_noZFP.txt

# File with the names of the selected TFs and their accession ID
# There can be more than one ID per TF
TF_NAME_ID_LIST=Selected_TF_name_ID.txt

OUTPUT_DIR='CreateNetwork_Mouse'

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  # All the BED files in all the replicates
  INPUT_TFBS=$OUTPUT_SUBDIR_1/*/TFBS_input/*
  
  # Origin file for TF-TF network construction
  OUTPUT_FILE_TF_TF=$OUTPUT_SUBDIR_1/Origin_Mouse_TF-TF_$peakset.txt
  
  # Origin file for network construction with TFs and all target genes
  OUTPUT_FILE_TF_ALL=$OUTPUT_SUBDIR_1/Origin_Mouse_TF-genes_$peakset.txt

  for file in $INPUT_TFBS
  
  do
  
    awk -F"\t" '{print $7"\t"$6}' $file >> tmp1.txt

  done

  sort tmp1.txt | uniq > tmp2.txt
  
  # The input TFs must be present in the origin file, but there can be some not
  # being regulated by other TFs, therefore we have to add their name-ID to the
  # origin file
  cat tmp2.txt $TF_NAME_ID_LIST | sort | uniq > $OUTPUT_FILE_TF_ALL

  # Filter the origin file to select only TFs for TF-TF network building
  awk -F'\t' 'NR==FNR{c[$1]++;next};c[$1] > 0' $SELECTED_TF $OUTPUT_FILE_TF_ALL > $OUTPUT_FILE_TF_TF

  # -F'\t': sets the field separator to tab.

  # NR==FNR: NR is the current input line number and FNR the current file's line
  #          number. The two will be equal only while the 1st file is being read.

  # c[$1]++; next: if this is the 1st file, save the 1st field in the c array.
  #                Then, skip to the next line so that this is only applied on
  #                the 1st file.

  # c[$1]>0: the else block will only be executed if this is the second file so
  #          we check whether field 1 of this file has already been seen
  #          (c[$1]>0) and if it has been, we print the line. In awk, the
  #          default action is to print the line so if c[$1]>0 is true, the
  #          line will be printed.

  rm tmp*.txt
  
done


