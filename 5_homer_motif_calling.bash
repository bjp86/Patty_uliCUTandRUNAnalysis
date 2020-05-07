#load homer
PATH=$PATH:/zfs1/shainer/homer/bin

#set input and output directories
BAMs=/Path/to/size_filtered_bams
tag_directories=/Path/to/tag_directories
UCSC_files=/Path/to/UCSC_files
regions_files=/Path/to/regions_files
motifs_files=/Path/to/motifs_files

#Use sorted bam to create a HOMER tag directory
makeTagDirectory $tag_directories/sample1_mouse_1_120/ $BAMs/sample1_mouse_1_120.bam

#Make a bed file with sample-specific tag directory
makeUCSCfile $tag_directories/sample1_1_120 -o $regions_files/sample1_mouse_1_120_regions_of_interest.bed

#Creat a txt file containing region information for each sample
annotatePeaks.pl $regions_files/sample1_mouseregions_of_interests.bed /path/to/mouse_genome -size 4000 -hist 20 -d $tag_directory/sample_1_1_120 > $regions_files/sample1 1_120_regions_of_interests.txt

#Use MotifsGenome.pl to perform motif analys on regions contained within sample-specific txt region files
findMotifsGenome.pl $regions_file/sample1_1_120_regions_of_interest.txt /path/to/mouse_genome $motifs_files/sample1_1_120_regions_of_interests_peaks.txt -size 4000

