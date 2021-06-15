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
It is recommended to create a parent directory with the needed input files and run all the following scripts from its location in the order specified here. At the end, several organized directories and subdirectories for each step will be obtained with the corresponding output files. The required input files are:
- Input BAM files containing the mapped ATAC-seq reads. The associated bam.bai index should be in the same directory (else it will be created).
- Input BED files containing the peak regions of interest for performing footprinting analysis. These peak files should be annotated to run **BINDetect.sh** correctly.
- Input FASTA file containing the reference genome to which the sequencing reads were mapped.
- Input BED file containing the blacklisted regions in the reference genome.
- Input motifs in either PFM, JASPAR or MEME format to scan for binding sites.
- Input txt with the names of acinar-expressed TFs to restrict the identified TFBS.

**ATACorrect.sh** runs TOBIAS ATACorrect function for each replicate in each of the assessed sets of peaks obtained from **Homer_merge_to_bed.sh** and **OCR_histone_mark_filter.sh** to correct the Tn5 inherent cutting pattern bias.

**ScoreBigwig.sh** runs TOBIAS ScoreBigwig function for each replicate in each of the assessed sets of peaks to calculate footprint scores.

**BINDetect.sh** runs TOBIAS BINDetect function for each replicate in each of the assessed sets of peaks to estimate specific TFBS based on the input motifs.

**Acinar_expressed_bound_TF_selection.sh** copies the BED files corresponding to the sites bound by the specified acinar-expressed TFs.

**TFBS_footprint_format.sh** correctly formats the previously selected BED files to be used as input for **CreateNetwork.sh** and **CreatenNetwork_individual_TF.sh**.

**Origin_file_maker.sh** generates the origin files needed for **CreateNetwork.sh** and **CreateNetwork_individual_TF.sh**.

## Visualization
**PlotAggregate** runs TOBIAS PlotAggregate function for each replicate in each of the assessed sets of peaks to generate aggregated views of footprint signals across regions.

**Venn_diagram.R** creates a venn diagram representing the overlap between different sets of peaks.

**Genomic_locations.R** creates a barplot representing the genomic location distribution of the assessed sets of peaks.

**


## Statistical analysis



## RNA-seq analysis
## scRNA-seq analysis
