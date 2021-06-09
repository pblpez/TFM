# TFM

# DESCRIPCIÓN DEL REPOSITORIO
In this repository is explained the methodology applied in the master's thesis entitled "Deciphering gene regulation network in normal mouse pancreas through a multi-omic integrative approach" along with the scripts and command line tools applied.

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
**Homer_merge_to_bed.sh** merge two or more input peak files to obtain a consensus peak file between all the replicates, which is transformed into bed format. This script was used to obtain the consensus OCRs between the ATAC-seq analysed replicates. It was used aswell to obtain the consensus peaks between the replicates of each histone mark analysed by ChIP-seq.


## RNA-seq analysis
## scRNA-seq analysis
