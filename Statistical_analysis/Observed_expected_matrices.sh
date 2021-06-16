#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 14-05-2021
#
################################# DESCRIPTION #################################
#
# This script generates matrices with the observed and expected number of 
# overlaps between the target genes identified by individual TF network
# approach and by TF ChIP-seq approach. The observed corresponds to the real
# overlap and the expected to the overlap obtained by comparing with random
# regions using "Common_targets_network_chip_shuffled.sh"
#
# These results are the input for "Consistent_results_significance.R".
#
################################# REQUIREMENTS ################################
#
# This script should be run from the same directory
# "Common_targets_network_chip_shuffled.sh" was run.
#
# Specify the path to the input directory with the files containing the number
# of observed common genes between network and ChIP-seq approaches, or copy the
# directory into the working directory. This is one of the outputs obtained from 
#"Network_chip_consistency.sh".
#
################################# MAIN ########################################

# Specify the path to the directory or copy it into working directory.
INPUT_OBS=Network_ChIP_gene_overlap

OUTPUT_DIR=Matrices

if ! [ -d $OUTPUT_DIR ]; then

  mkdir $OUTPUT_DIR
  
fi

for peakset in ATAC H3K4me3 H3K27ac_enhancers H3K27ac_promoters

do
  
  for if_motif in all motif no_motif
  
  do
 
  
    for TF in Bhlha15 Foxa2 Gata4 Gata6 Hnf1a Nfic Nr5a2 Ptf1a Rbpjl
    
    do

      # As the observed values are integers, the expected mean values are also calculated as integers.
      
      OVERLAP_EXP=$(awk '{ total += $2 } END { print int(total/NR) }' 'Permutations'/$peakset/$if_motif/$TF'_'$peakset'_'$if_motif'_permutationNumbers.txt')

      TOTAL=$(cat $peakset'_network_target_genes'/$peakset'_'$TF'_genes_filtered.txt' | sed '/^[[:space:]]*$/d' | wc -l)
      
      NO_OVERLAP_EXP=$(($TOTAL - $OVERLAP_EXP))
      
      OVERLAP_OBS=$(cut -d ' ' -f 3 $INPUT_OBS/$peakset/$if_motif/$TF'_network_chip_overlap_nums.txt' | tail -n +5)
      
      NO_OVERLAP_OBS=$(($TOTAL - $OVERLAP_OBS))
     
      printf "$OVERLAP_OBS $OVERLAP_EXP\n$NO_OVERLAP_OBS $NO_OVERLAP_EXP\n\n" > $OUTPUT_DIR/$TF'_'$peakset'_'$if_motif'_matrix.txt'
      
    done
    
  done

done
