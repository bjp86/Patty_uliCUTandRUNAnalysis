#load java 1.8.0_121 (for picard), picard v2.18.12, and samtools v1.9
module load java/1.8.0_121
module load picard/2.18.12
module load samtools/1.9

#set input and output directories
SAMs=Path/to/sam_files
Picard1=/Path/to/bams_P1
Picard2=/Path/to/bams_Picard2
filtered_sams=/Path/to/filtered_sams

#make output directories as necessary
mkdir $Picard1
mkdir $Picard2
mkdir $filtered_sams

#use picard to convert bowtie2 output sample sams to coordinate sorted bams, output to $Picard1
java -Xmx4g -jar /path/to/picard-tools-2.5.0/picard.jar SortSam INPUT=$SAMs/sample1_mouse.sam \
OUTPUT=$Picard1/sample1_mouse_Picard.bam VALIDATION_STRINGENCY=LENIENT \
TMP_DIR=/tmp SORT_ORDER=coordinate

#use picard to remove PCR duplicates from coordinate sorted bams, output to $Picard2
java -Xmx4g -jar /zfs1/shainer/picard-tools-2.5.0/picard.jar MarkDuplicates INPUT=$Picard1/sample1_mouse_Picard.bam \
OUTPUT=$Picard2/sample1_mouse_Picard2.bam VALIDATION_STRINGENCY=LENIENT \
TMP_DIR=/tmp METRICS_FILE=dup.txt REMOVE_DUPLICATES=true

#use samtools to convert coordinate sorted bams to sam files
samtools view -h -o $Picard2/sample1_mouse_Picard2.sam $Picard2/sample1_mouse_Picard2.bam

#use samtools to remove reads with MAPQ<10 from file, output to $filteredsams
samtools view -Sq 10 $Picard2/sample1_mouse_Picard2.sam > $filtered_sams/sample1_mouse_filtered.sam

#use following custom perl scripting to extract fragment lengths information from filtered sample sams
perl -e ' $col=8;  while (<>) { s/\r?\n//; @F = split /\t/, $_; $val = $F[$col]; if (! exists $count{$val}) { push @order, $val } $count{$val}++; } foreach $val (@order) { print "$val\t$count{$val}\n" } warn "\nPrinted number of occurrences for ", scalar(@order), " values in $. lines.\n\n"; ' $filered_sams/sample1_mouse_filtered.sam > $filtered_sams/sample1_mouse_filtered_unique_reads.txt
#use following custom perl scripting to extract fragment lengths information from spike-in sams
perl -e ' $col=8;  while (<>) { s/\r?\n//; @F = split /\t/, $_; $val = $F[$col]; if (! exists $count{$val}) { push @order, $val } $count{$val}++; } foreach $val (@order) { print "$val\t$count{$val}\n" } warn "\nPrinted number of occurrences for ", scalar(@order), " values in $. lines.\n\n"; ' $SAMs/sample1_sacCer.sam > $filtered_sams/sample_sacCer3_unique_reads.txt

#input fragment length files into desired spreadsheet to visualize fragment length distributions
