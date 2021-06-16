#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 14-05-2021
#
################################# DESCRIPTION #################################
#
# This script extracts and generates a list with the p-values obtained from the
# Chi-squared test performed in each of the obtained results.
#
################################# REQUIREMENTS ################################
#
# "Observed_expected_matrices.sh" and "Consistent_results_significance.R"
# should have been previously run.
#
# This script should be run from the parent directory of "Matrices", where are
# all the files with the matrices and Chi-squared results. The parent directory
# is the same from which "Common_targets_network_chip_shuffled.sh" and
# "Observed_expected_matrices.sh" were run.
#
################################# MAIN ########################################

if [ -f 'p-values.txt' ]; then
  
  rm 'p-values.txt'
  
fi

for network in ATAC H3K4me3 H3K27ac_enhancers H3K27ac_promoters

do
  
  for if_motif in all motif no_motif
  
  do
  
    for TF in Bhlha15 Foxa2 Gata4 Gata6 Hnf1a Nfic Nr5a2 Ptf1a Rbpjl
    
    do
      
      pvalue=$(tail -n +6 'Matrices'/$TF'_'$network'_'$if_motif'_matrix.txt' | head -n 1)
      
      printf $TF'_'$network'_'$if_motif': '$pvalue'\n\n' >> 'p-values.txt'
      
    done
  
  done
  
done
