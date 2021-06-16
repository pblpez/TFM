#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 27-01-2021
#
################################# DESCRIPTION #################################
#
# Copy the BED files corresponding to the sites bound by the TFs specified in
# "SELECTED_TF" into a new directory. This is performed for each replicate in
# each of the assessed sets of peaks. In this work, "SELECTED_TF" corresponds
# to the acinar-expressed TFs, excluding ZFP.
#
# The aim of this script is to select and organize the information of interest
# between all the outputs obtained from BINDetect step. 
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
# BINDetect.sh should have been run previously. This script selects the outputs
# of interest from BINDetect for subsequent analysis.
#
# Specify the path to "SELECTED_TF". It is recommended to include it in the
# parent directory as described in:
# https://github.com/PabloPerez5/TFM/blob/main/README.md
#
# The output directories are specified in the for loops and should correspond
# to the tested peak sets and replicates.
#
################################# MAIN ########################################


# File with the names of the selected acinar-expressed TFs (1 name per row)
SELECTED_TF=Acinar_expressed_TF_noZFP.txt

OUTPUT_DIR='Selected_acinar_expressed_TFs'

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
    
    # Input directory with the respective subdirectories for each TF
    INPUT_DIR=BINDetect_Mouse/$peakset/$replicate
    
    echo "Searching for bound.bed files for the specified TFs in "$peakset"/"$replicate
    echo "It might take some minutes..."
    
    while read -r FILE
    
    do
    
      find $INPUT_DIR -iname "$FILE""_*_bound*.bed" -exec cp {} $OUTPUT_SUBDIR_2 \;
      
    done < $SELECTED_TF # Corresponds to $FILE and it is read to find matches
    
    if [ $? -ne 0 ]; then
    
      echo "Files could not be copied"
      
      else
      
      echo "Files copied successfully!"
      
    fi


  #  find         - It's the command to find files and folders in Unix-like
  #                   systems.
  
  #  -iname "$FILE""_*_bound*.bed" - Search for files with names matching to
  #                                  "$FILE""_*_bound*.bed".
  
  #  -exec cp     - Tells you to execute the 'cp' command to copy files from
  #                   source to destination directory.
  
  #  {}           - is automatically replaced with the file name of the files
  #                 found by 'find' command.
  
  #  $OUTDIR      - Target directory to save the matching files.
  
  #  \;           - Indicates that the commands to be executed are now complete
  #                 and to carry out the command again on the next match.


  
  done
  
done

