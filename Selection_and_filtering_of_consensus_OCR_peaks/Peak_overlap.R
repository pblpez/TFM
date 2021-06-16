# Author: Pablo Pérez Martínez
# Date: 22-11-2021

################################# Description #################################
#
# This script creates a venn diagram representing the overlap between different
# sets of peaks. 
# This is an example of the functions used to plot the venn diagrams
# represented in the TFM's manuscript. Specifically, this corresponds to the
# overlapping peaks between the different human acinar pancreas replicates.
# Data not shown in the manuscript.
#
################################# Main ########################################

v <- eulerr::euler(c( rep2_vs_rep3 = 2783, rep1_vs_rep3 = 5677, 
                      rep1_vs_rep2 = 2573,
                      "rep1_vs_rep3&rep2_vs_rep3" = 73, 
                      "rep1_vs_rep2&rep2_vs_rep3" = 142,
                      "rep1_vs_rep2&rep1_vs_rep3" = 1985, 
                      "rep1_vs_rep2&rep1_vs_rep3&rep2_vs_rep3" = 11956),
                   shape = "circle")

plot(v, fills = c('cadetblue3','yellow1', 'firebrick1', 'olivedrab2',
                  'darkorchid1', 'orange', 'darkorange4'),labels = 
       c('Adult2_vs_Juvenile','Adult1_vs_Juvenile', 'Adult1_vs_Adult2'), 
     quantities = list(fontsize = 10), main = "Tn5 cut peaks identified in human replicates")
