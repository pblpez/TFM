# TFM

# DESCRIPCIÓN DEL REPOSITORIO
In this repository is explained the methodology applied in the master's thesis entitled "Deciphering gene regulation network in normal mouse pancreas through a multi-omic integrative approach" along with the scripts and command line tools applied.

## ATAC-seq analysis
To analyse the ATAC-seq data for Open Chromatin Regions (OCRs) detection, the ENCONDE ATAC-seq pipeline developed by Anshul Kundaje's laboratory was used.
<br />
<br />
Caper (Cromwell Assisted Pipeline ExecutoR) was used to run the pipeline from FASTQ to peak calling and quality control in an automated way.

```
$ caper run [WDL script] -i [Input JSON file containing information of genomic data files, parameters and metadata]
```
For detailed information on how to configure and run the ENCODE ATAC-seq pipeline with caper see https://github.com/ENCODE-DCC/atac-seq-pipeline.

## C
