# Introduction

In this repository is explained the code used to perform the analyses and represent the results described in the master's thesis entitled "Deciphering a gene regulation network in normal mouse pancreas through a multi-omic integrative approach". Each subsection of this repository is explained the "Methods" section of the manuscript. Here are overviewed the scripts and command line tools applied to perform each analysis. Further description on how to run each script, its funtionality and requirements is included in the corresponding script.

## ATAC-seq analysis
To analyse the ATAC-seq data for Open Chromatin Regions (OCRs) detection, the ENCONDE ATAC-seq pipeline developed by Anshul Kundaje's laboratory was used. Two female and two male replicates were analysed separately.
<br />
<br />
Caper (Cromwell Assisted Pipeline ExecutoR) was used to run the pipeline from FASTQ files to peak calling and quality control in an automated way.

```
$ caper run [WDL script] -i [Input JSON file containing information of genomic data files, parameters and metadata]
```
For detailed information on how to configure and run the ENCODE ATAC-seq pipeline with caper see https://github.com/ENCODE-DCC/atac-seq-pipeline.
<br />
<br />
**Output files**
<br />
<br />
Cromwell Output Organizer (Croo) can be used to organize the outputs from Caper (A metadata.json file can be found on Caper's output directory). Croo is installed together with pipeline's Conda environment. For more information see https://github.com/ENCODE-DCC/croo.
```
$ croo [Metadata JSON file]
```
The output files used for the footprinting analysis performed in this work are specified here, for more information regarding the outputs see https://github.com/ENCODE-DCC/atac-seq-pipeline. 
<br />
<br />
Quality Control html report.
<br />
<br />
Filtered BAM files containing the reads mapped to the reference genome:
- Female_rep1.trim.srt.nodup.no_chrM_MT.bam
- Female_rep2.trim.srt.nodup.no_chrM_MT.bam
- Male_rep1.trim.srt.nodup.no_chrM_MT.bam
- Male_rep2.trim.srt.nodup.no_chrM_MT.bam

Peak files containing the OCRs between replicates:
- Female_rep1_vs_rep2.idr0.05.bfilt.narrowPeak.gz
- Male_rep1_vs_rep2.idr0.05.bfilt.narrowPeak.gz

## ChIP-seq analysis

## Selection and filtering of consensus OCR peaks
**Homer_merge_to_bed.sh** merge two or more input peak files to obtain a consensus peak file between all the replicates in bed format. This script was used to obtain the consensus OCRs between the ATAC-seq analysed replicates. It was used aswell to obtain the consensus peaks between the replicates of each histone mark analysed by ChIP-seq.

**OCR_histone_mark_filter.sh** splits the H3K27ac ChIP-seq peaks into a promoter and an enhancer subset. The different consensus sets of peaks from the different histone mark ChIP-seq analysed are intersected with the consensus ATAC-seq OCRs obtained with **Homer_merge_to_bed.sh**.

## Peak annotation
Annotation of bed files with consensus peak regions was performed using HOMER annotatePeaks.pl function. -m option was used to annotate peak files from ChIP-seq performed for individual TFs. This option allowed to introduce position probability matrices (PPMs) containing motif information.
```
$ annotatePeaks.pl <BED file with peaks> <reference genome (mm10)> -gtf <gtf file with annotations> -m <motif> > <output file>
```
The input PPMs specified in the -m option were obtained by performing HOMER *de novo* analysis on the corresponding set of peaks to be annotated.
```
$ findMotifsGenome.pl <BED file with peaks> <reference genome (mm10)> <output directory> -size given
```
## Footprinting analysis
It is recommended to create a parent directory with the input files for **ATACorrect.sh** and run all the following scripts from its location in the order specified here. At the end, several organized directories and subdirectories for each step will be obtained with the corresponding output files.
**ATACorrect.sh** runs TOBIAS ATACorrect function for each replicate in each of the assessed sets of peaks obtained from **Homer_merge_to_bed.sh** and **OCR_histone_mark_filter.sh**.

## RNA-seq analysis
## scRNA-seq analysis
