#Load fastqc v0.11.9
module load fastqc/0.11.9

#set path Fastq directories and output directories
fastq=/Path/to/raw_fastq_files
out=/Path/to/output_directory

#make output directory if needed
mkdir $out


#perform a FastQC analysis for every fastq, including for each read pair
fastqc -o $out $fastq/Sample1_R1.fastq
fastqc -o $out $fastq/Sample1_R2.fastq

