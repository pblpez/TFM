# Author: Pablo Pérez Martínez
# Date: 14-05-2021

################################# Description #################################
#
# This script performs Pearson's Chi-squared test to determine the statistical
# significance of the common results between network and ChIP-seq approaches.
#
# The results are written into the input matrices files.
#
################################# Requirements ################################
#
# Specify the path to the directory with all matrices obtained from running
# "Observed_expected_matrices.sh"
#
################################# Main ########################################

library(tseries)

dir <- # Path to directory with input matrices
  
files <- list.files(path = dir, full.names = TRUE)

for(TF in files) {
  m <- read.matrix(TF)
  t <- chisq.test(m,correct = TRUE)
  lapply(t, write, TF, append = TRUE)
  
}

