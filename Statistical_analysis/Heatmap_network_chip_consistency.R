# Author: Pablo Pérez Martínez
# Date: 17-05-2021

################################# Description #################################
#
# This script creates a heatmap representing the percentage of target genes of
# individual TFs identified by network approach that overlaps with ChIP-seq 
# target genes identified for the same TFs.
# It generates 3 columns corresponding to "all", "motif" and "no motif" 
# ChIP-seq regions split as described in the TFM's manuscript.
#
################################# Requirements ################################
#
# Load a .csv file with the percentages of target genes identified by network
# approach that overlap with target genes identified by ChIP-seq approach.
# These percentages are obtained after running "Network_chip_consistency.sh"
# There should be a row for each TF and 3 columns corresponding to "motif",
# "no_motif" and "all" split. Rownames and colnames should be present.
#
################################# Main ########################################

library(ggplot2)
library(gplots)

#########################################################
## B) Reading in data and transform it into matrix format
#########################################################

file_percentages <- # Path to .csv file
  
data <- read.csv(file = file_percentages)

rnames <- data[,1]

mat_data <- data.matrix(data[,2:ncol(data)])

rownames(mat_data) <- rnames

#########################################################
## C) Customizing and plotting the heat map
#########################################################

my_palette <- colorRampPalette(c("yellow", "orange", "red4"))(n = 100)

heatmap.2(mat_data,
          cellnote = mat_data,  # same data set for cell labels
          notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          dendrogram="none",    # only draw a row dendrogram
          Colv="NA",            # turn off column clustering
          key.xlab = "NA",
          key.title = "NA",
          cexCol = 1.5)            


