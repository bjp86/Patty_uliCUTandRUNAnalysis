#load bowtie2v2.3.5.1
module load bowtie2/2.3.5.1

#set paths for input, output, and genome directories
fastqfile=/Path/to/fastq_files
out=/Path/to/sam_files
mouse=/Path/to/mouse_reference_genome #may be different genome with your sample/analysis
SacCer=/Path/to/yeast_reference_genome #may be different spike-in genome with your analysis

#make output directory as necessary
mkdir $out

#For each sample and pair of reads, align to sample and spike-in reference genome

#Read aligning to sample reference genome
bowtie2 -q -N 1 -X 1000 -x $mouse \
-1 $fastqfile/sample1_R1.fastq \
-2 $fastqfile/sample2_R2.fastq \
-S sample1_mouse.sam

#Read aligning to spike-in reference genome
bowtie2 -q -N 1 -X 1000 -x $SacCer \
-1 $fastqfile/sample1_R1.fastq \
-2 $fastqfile/sample2_R2.fastq \
-S sample1_spikein.sam


