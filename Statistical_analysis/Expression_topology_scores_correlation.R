# Author: Pablo Pérez Martínez
# Date: 05-03-2021

################################# Description #################################
#
# This script creates a correlation plot between different topological measures
# as well as between topological measurements and TF mean expression levels.
#
################################# Requirements ################################
#
# Load a .csv file with a column containing the TF mean expression values and 
# one or more columns containing the scores for topological measurements.
# Specify x and y values as the column names from the columns to be compared.
#
################################# Main ########################################

library(ggpubr)

file_scores <- # Path to .csv file
  
TF_rank <- read.csv(file = file_scores)

ggscatter(TF_rank, x = "Mean_Expression", y = "Degree", size = 1,
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Mean_Expression", ylab = "Degree") + 
  scale_x_continuous(expand = c(0, 0), limits = c(0, NA)) + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA))
