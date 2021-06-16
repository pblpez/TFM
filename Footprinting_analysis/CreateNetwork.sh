#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 01-02-2021
#
################################# DESCRIPTION #################################
#
# This script runs TOBIAS CreateNetwork function for each replicate in each of
# the assessed sets of peaks. This function models the interactions between
# the different TFs selected as acinar-expressed. To model the interactions 
# between TFs and all their targets see REQUIREMENTS.
# To model the interactions between individual TFs and all their targets use
# "CreateNetwork_individual_TF.sh" in:
# https://github.com/PabloPerez5/TFM/edit/main/README.md
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
# - adjacency.txt: Adjacency list
# - edges.txt: File from which we can generate a Cytoscape network visualization
#              (Sites_3 is the TF source and Origin_0 the target)
# - <TF>_path.txt: Possible paths taking <TF> as source
# - <TF>_path_edges.txt: Specifies the final targets for <TF> and its direct
#                        source, as well as the number of edges to reach the
#                        target from the origin source (<TF>)
#
# For further information see:
# https://github.com/loosolab/TOBIAS/wiki/CreateNetwork
#
################################# REQUIREMENTS ################################
#
# "TFBS_footprint_format.sh" and "Origin_file_maker.sh" should have been
# previously run.
#
# To build a global network with all selected TFs and all their targets,
# specify the path of ORIGIN_INPUT to:
# $OUTPUT_SUBDIR_1/Origin_Mouse_TF-genes_$peakset.txt
#
# The output directories are specified in the for loops and should correspond
# to the tested peak sets and replicates.
#
################################# MAIN ########################################

OUTPUT_DIR='CreateNetwork_Mouse'

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  # Input origin file with TF names-IDs pairs
  # Change path to $OUTPUT_SUBDIR_1/Origin_Mouse_TF-TF_$peakset.txt to build a
  # global network representing all TF-target genes interactions
  ORIGIN_INPUT=$OUTPUT_SUBDIR_1/Origin_Mouse_TF-TF_$peakset.txt

  for replicate in Female_Rep_1 Female_Rep_2 Male_Rep_1 Male_Rep_2

  do
  
    OUTPUT_SUBDIR_2=$OUTPUT_SUBDIR_1/$replicate
      
    # Input BED files to build the network from
    TFBS_INPUT=$OUTPUT_SUBDIR_2/TFBS_input/*
           
    # Command to run TOBIAS CreateNetwork
    TOBIAS CreateNetwork --TFBS $TFBS_INPUT --origin $ORIGIN_INPUT --outdir $OUTPUT_SUBDIR_2
    
  done
  
done
