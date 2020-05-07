# **uliCUT&RUNAnalysis Analysis Pipeline**

## **Description**
ultra-low input Cleavage Under Target and Release Using Nuclease (uliCUT&RUN) is a variant of the CUT&RUN technique developed by the Henikoff group based on previously established ChIC technology to probe factor localization on chromatin. The data analysis described herein is a basic uliCUT&RUN bioin formatic pipeline that step-by-step guides the user to process raw fastq files into occupancy visualization plots and perform binding motif analysis at factor-occupied regions of interest. This analysis requires a basic understanding of UNIX commands but can be run on a standard computing cluster. For advanced users, we suggest alternatives to the programs and packages used in these suggested analyses (and in the accompanying manuscript) which serve as a starting point for a custom analysis pipeline.

## **Requirements**

- FastQC, v0.11.9

- Samtools, v1.9

- Bowtie2, v2.3.5.1

- Picard, v2.18.12

- deepTools, v3.3.0

- HOMER, v4.10.3

## **Pipeline Usage**

1. *fastQC.bash*
- Input: Raw paired fastq files
- Output: Html fastq quality assessment report

2. *bowtie2.bash*
- Input: Quality-assessed paired fastq files
- Output: Paired end sequence alignment map (SAM) files for sample and spike-in 

3. *picard.bash*
- Input: Paired end sample SAM files
- Output: Paired end sample SAM files filtered of PCR duplicates and reads MAPQ<10 and text file containing lengths of all reads within sample and spike-in SAMs.

3.5. *Fragment Distribution profile generation with desired spread sheet program*
- Input: Text files of fragment lengths of reads in sample and spike-in SAMs
- Output Fragment Distribution profile

4. *size_class.bash with bowtie2.header*
- Input: Filtered sample SAM files and bowtie2.header
- Output: Size-class filtered sample binary alignment map (BAM) files

5. *deepTools.bash and/or homer_motif_calling.bash*

- For deepTools.bash:
  - Input: Size-class filtered sample BAM files and text file
  - Output: DeepTools-generated heatmap and metaplot visualizations of factor over regions of interest

- For homer_motif_analysis.bash:
  - Input: Size-class filtered sample BAM files 
  - Output: HOMER-generated Motif matrix for factor-occupied regions of interest

## **Software Sources**

- FastQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- Samtools (http://www.htslib.org/download/)
- Bowtie2 (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
- Picard (https://broadinstitute.github.io/picard/)
- deepTools (https://deeptools.readthedocs.io/en/develop/index.html)
- HOMER (http://homer.ucsd.edu/homer/)

## **Acknowledgements**

We thank the Henikoff group for original development of CUT&RUN and discussion regarding application. We thank A. Boskovic and T. Fazzio for assistance in development and application of uliCUT&RUN. We thank members of the Hainer lab and the program developers for aid in development of this data analysis pipeline.
