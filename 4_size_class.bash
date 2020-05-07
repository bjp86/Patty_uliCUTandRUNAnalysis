#load samtools v1.9
module load samtools/1.9

#set paths to input and output directories
filtered_sams=/Path/to/filtered_sams
bowtie2_header=/Path/to/bowtie2.header
out=/Path/to/size_filtered_bams

#create output directories as necessary
mkdir $out

#Use following custom scripting with included file (bowtie2.header):
#Write all reads length 1-120bps into new sam file containing only reads length 1-120bp, output to $out
awk ' $9 <= 120 && $9 >= 1 || $9 >= -120 && $9 <= -1 ' $SAMs/sample1_mouse_filtered.sam > $out/sample1_mouse_1_120.sam

#Create a bowtie2 header for new 1-120bp samfile with bowtie2.header
cp $bowtie2_header/bowtie2.header $out/sample1_mouse_1_120.header

#Concatenate 1-120bp specific samfile to end of new bowtie2 header file
cat $out/sample1_mouse_1_120.sam >> $out/sample1_mouse_1_120.header

#Delete old 1-120bp specific samfile
rm $out/sample1_mouse_1_120.sam

#Copy 1-120 specific samfile with new bowtie2 header to 
mv $out/sample1_mouse_1_120.header $out/sample1_mouse_1_120.sam

#use samtools to convert sam file to bam file, then index file bam file for deepTools analysis
samtools view -S -t /Path/to/mouse.chrom.sizes -b -o $out/sample1_mouse_1_120.bam $out/sample1_mouse_1_120.sam
samtools index $out/sample1_mouse_1_120.bam

#Delete unused sam file
rm $out/sample1_mouse_1_120.sam
