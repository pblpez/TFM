#!/bin/bash

# Author: Pablo Pérez Martínez
#
# Date: 06-04-2021
#
################################# DESCRIPTION #################################
#
# From the "edge" table of each consensus individual TF network obtained with 
# cytoscape, extracts the column with gene names.
# 
# Filter the network and ChIP-seq target genes by expression levels. Keep genes
# with >= 1 RPKM in normal mouse pancreas.
#
# Compare both filtered lists of target genes to determine exclusive and common
# target genes between network and ChIP-seq approaches.
#
# Calculates the number of exclusively and commonly identified target genes
# between network and ChIP-seq approaches.
#
# Calculates the percentage of target genes identified by network approach that
# overlaps with target genes identified by ChIP-seq
#
################################# OUTPUT ######################################
#
# - List of network target genes filtered by expression levels (>= 1 RPKM)
# - List of ChIP-seq target genes filtered by expression levels (>= 1 RPKM)
# - List of target genes exclusively identified by network approach (column 1),
#   exclusively identified by ChIP-seq approach (column 2) and commonly
#   identified by both approaches (column 3)
# - txt file with the number of genes exclusively identified by network
#   approach, by ChIP-seq approach and commonly identified by both approaches.
#
################################# REQUIREMENTS ################################
#
# Edge tables from each network should have been extracted from the 
# corresponding Cytoscape session and should be located in a directory called 
# "Edge_tables" inside CreateNetwork_Mouse/$peakset/
#
# The path to a file with the list of pancreas-expressed TFs should be
# specified.
#
# Target genes from annotated ChIP-seq were manually extracted from the files.
# The path to the files containing the list of ChIP-seq target genes should
# be specified in "INPUT_CHIP_GENES".
#
# Output directories to save the filtered lists of target genes should be
# specified in OUTPUT_NETWORK_DIR and OUTPUT_CHIP_DIR. This script creates new
# subdirectories within existing directories. If "CreateNetwork.sh" was
# previously run, OUTPUT_NETWORK_DIR should not be changed. For OUTPUT_CHIP_DIR
# it is recommended to have a similar structure of directories as shown here.
#
################################# MAIN ########################################

# Check that the final files where overlap percentages will be saved does not
# already exists
rm "Network_ChIP_gene_overlap/"*"/"*"/"*"_overlap_percentages.txt"

EXPRESSED_TF='Pancreas_expressed_TFs.txt'

OUTPUT_DIR='Network_ChIP_gene_overlap'

if ! [ -d $OUTPUT_DIR ]; then

  mkdir $OUTPUT_DIR
  
fi

for peakset in ATAC H3K4me3 H3K27ac_promoters H3K27ac_enhancers

do
  
  OUTPUT_SUBDIR_1=$OUTPUT_DIR/$peakset
  
  if ! [ -d $OUTPUT_SUBDIR_1 ]; then

  mkdir $OUTPUT_SUBDIR_1
  
  fi
  
  OUTPUT_NETWORK_DIR=CreateNetwork_Mouse/$peakset/Filtered_genes
  
  if ! [ -d $OUTPUT_NETWORK_DIR ]; then

  mkdir $OUTPUT_NETWORK_DIR
  
  fi
  
  
  for TF in Bhlha15 Foxa2 Gata4 Gata6 Hnf1a Myrf Nfic Nr5a2 Ptf1a Rbpjl

  do

    INPUT_EDGE_TABLE=CreateNetwork_Mouse/$peakset/Edge_tables/'Merged_'$peakset'_'$TF'_edge.csv'
    
    # Extract the individual network target genes from "edge" tables and
    # format to keep the gene names with the first letter in uppercase
    # followed by lowercase
    # Filter the network target genes by expression levels (>= 1 RPKM)
    comm -12 <(awk -F"," '{print $12}' $INPUT_EDGE_TABLE | tail -n +2 | tr -d '"' | sed -e 's/.*/\L&/' -e 's/\w/\u&/' | sort) <(sort $EXPRESSED_TF | sed -e 's/.*/\L&/' -e 's/\w/\u&/') > $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt'
    
    for if_motif in all motif no_motif 
    
    do
    
      OUTPUT_SUBDIR_2=$OUTPUT_SUBDIR_1/$if_motif
  
      if ! [ -d $OUTPUT_SUBDIR_2 ]; then

        mkdir $OUTPUT_SUBDIR_2
    
      fi

    OUTPUT_CHIP_DIR=ChIP_TF_analysis/$if_motif/Filtered_genes
    
    if ! [ -d $OUTPUT_CHIP_DIR ]; then

    mkdir $OUTPUT_CHIP_DIR
  
    fi
    
    INPUT_CHIP_GENES=ChIP_TF_analysis/$if_motif/$TF'_genes_'$if_motif'.txt'
    
    # Filter the ChIP-seq target genes by expression levels (>= 1 RPKM)
    comm -12 <(sort $INPUT_CHIP_GENES | sed -e 's/.*/\L&/' -e 's/\w/\u&/') <(sort $EXPRESSED_TF | sed -e 's/.*/\L&/' -e 's/\w/\u&/' | uniq) > $OUTPUT_CHIP_DIR/$TF'_genes_'$if_motif'_filtered.txt'

    # Overlap between network and ChIP-seq target genes
    # First column = Network exclusive genes
    # Second column = ChIP-seq exclusive genes
    # Third column = Common target genes
    comm $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt' $OUTPUT_CHIP_DIR/$TF'_genes_'$if_motif'_filtered.txt' > $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap.txt'
    
    # The following lines creates a .txt file for each TF containing the number
    # of target genes exlusively identified in the network (row 1), exclusively
    # identified in the ChIP-seq (row 2) and commonly identified (row 3)
    
    # Number of target genes exclusively identified in the network
    printf "Network only: " > $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap_nums.txt'
      comm -23 $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt' $OUTPUT_CHIP_DIR/$TF'_genes_'$if_motif'_filtered.txt' | wc -l >> $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap_nums.txt'
       
    # Number of target genes exclusively identified in the ChIP
    printf "\nChip-seq only: " >> $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap_nums.txt'
      comm -13 $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt' $OUTPUT_CHIP_DIR/$TF'_genes_'$if_motif'_filtered.txt' | wc -l >> $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap_nums.txt'
      
    # Number of common target genes between network and ChIP-seq approaches
    printf "\nCommon targets: " >> $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap_nums.txt'
      comm -12 $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt' $OUTPUT_CHIP_DIR/$TF'_genes_'$if_motif'_filtered.txt' | wc -l >> $OUTPUT_SUBDIR_2/$TF'_network_chip_overlap_nums.txt'
      
    # The following lines calculate the percentage of target genes identified
    # by network approach overlapping with target genes identified by Chip-seq
    
    common_genes=$(comm -12 $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt' $OUTPUT_CHIP_DIR/$TF'_genes_'$if_motif'_filtered.txt' | wc -l)
    
    total_network_genes=$(cat $OUTPUT_NETWORK_DIR/$TF'_genes_filtered.txt' | wc -l)
    
    printf "\nPercentage_overlap_"$network"_"$TF"_"$if_motif": " >> $OUTPUT_SUBDIR_2'/'$peakset'_overlap_percentages.txt'
    
    echo $(($common_genes*100/$total_network_genes)) >> $OUTPUT_SUBDIR_2'/'$peakset'_overlap_percentages.txt'

    done
    
  done
  
done

