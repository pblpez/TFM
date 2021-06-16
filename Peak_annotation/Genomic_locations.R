# Author: Pablo Pérez Martínez
# Date: 4-05-2021

################################# Description #################################
#
# This script creates a barplot representing the genomic location distribution 
# of the different sets of peaks specified. This code corresponds to the
# representation of the figure 4E of the TFM's manuscript.
# Percentages are indicated on the "y" axis and peak sets on the "x" axis.
#
################################# Main ########################################

library(ggplot2)
library(viridis)
library(hrbrthemes)
library(tidyr)
library(dplyr)
library(tibble)

network <- c(rep("ATAC", 5), rep("ATAC+H3K4me3", 5),
             rep ("ATAC+H3K27ac\npromoters", 5), 
             rep ("ATAC+H3K27ac\nenhancers", 5))
location <- rep(c("Promoter", "Exon", "Intron", "Intergenic", "TTS"), 4)
value <- c(c(6831, 3283, 15375, 12273, 662), c(6580, 2545, 4297, 2748, 238), 
           c(6164, 2345, 4375, 1572, 232), c(20, 309, 5515, 4873, 160))
data <- data.frame(network, location, value)

# To order the bars positions
data$network <- factor(data$network, levels = c("ATAC", "ATAC+H3K4me3",
                                                "ATAC+H3K27ac\npromoters", 
                                                "ATAC+H3K27ac\nenhancers"))
data$location <- factor(data$location, levels = c("Promoter", "Exon", "Intron",
                                                  "Intergenic", "TTS"))

ggplot(data, aes(fill=location, y=value, x=network)) +
  geom_bar(position="fill", stat="identity") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_viridis(discrete = T) +
  ggtitle("Genomic locations of different peaks sets") +
  xlab("") +
  ylab("Percentage of peaks") +
  theme(axis.text = element_text(size = 8, colour = "black"))
