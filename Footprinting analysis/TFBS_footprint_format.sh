#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 27-01-2021
#
################################# DESCRIPTION #################################
#
# This script correctly formats the BED files previously selected with
# "Acinar_expressed_bound_TF_selection.sh" to be used as input for TOBIAS
# CreateNetwork tool (CreateNetwork.sh).
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
# This script should be run right after having executed correctly 
# "Acinar_expressed_bound_TF_selection.sh". The input BED files should have the
# output format from TOBIAS BINDetect with default options. The input BED files
# should contain annotated TFBS (target genes should be specified).
#
# The output directories are specified in the for loops and should correspond
# to the tested peak sets and replicates.
#
################################# MAIN ########################################

OUTPUT_DIR='CreateNetwork_Mouse'

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
    
    # The output from this script is sent to TFBS_input directory, which is a
    # needed input for the next step (CreateNetwork.sh)
    OUTPUT_SUBDIR_3=$OUTPUT_SUBDIR_2/TFBS_input
    
    if ! [ -d $OUTPUT_SUBDIR_3 ]; then

      mkdir $OUTPUT_SUBDIR_3
    
    fi
    
    INPUT_BED_FILES=Selected_acinar_expressed_TFs/$peakset/$replicate/*

    for file in $INPUT_BED_FILES
    
    do
      
      # Extract the names of the TF with the first letter in uppercase followed
      # by lowercase
      awk -F"\t" '{print $4}' $file | cut -d "_" -f 1 | sed -e 's/.*/\L&/' -e 's/\w/\u&/' > tmp1.txt
      
      # Extract the columns corresponding to chr and start-end coordinates
      awk -F"\t" '{print $1"\t"$2"\t"$3}' $file > tmp2.txt
      
      # Extract the columns corresponding to the TFBS-Scores, target genes IDs,
      # target genes names and footprint-scores (all the sites from the "bound"
      # file has passed the footprint-score threshold established to be
      # considered as bound by the corresponding TF)
      awk -F"\t" '{print $5"\t"$16"\t"$17"\t"$22}' $file > tmp3.txt
      
      names=$(cat tmp1.txt)
	
      coordinates=$(cat tmp2.txt)
	
      annotations=$(cat tmp3.txt)
	
      # Generate a unique BED file with the name of the corresponding TF in the
      # specified output directory
      paste <(echo "$coordinates") <(echo "$names") <(echo "$annotations") > $OUTPUT_SUBDIR_3"/$(head -1 tmp1.txt).bed"
      rm tmp*.txt
      
    done
      
  done
  
done

