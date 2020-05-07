#load deepTools v3.3.0
module load deeptools/3.3.0

#set paths to input and output directories
spike_in_reads=/Path/to/sample1_spikein_unique_reads
bams=/Path/to/size_filtered_bams
bws=/Path/to/size_filtered_bws
bed=/Path/to/annotation_file.bed
mat=/Path/to/matrix_files
plots=/Path/to/plots

#create directories as needed
mkdir $bws
mkdir $mat
mkdir $plots


#Sum all mappable reads in spike-in SAM to generate an inverse counts per million (ICPM) value for normalization
cp $spike_in_reads/sample1_spikein_unique_reads.txt $spike_in_reads/spike_in_reads.txt 
sed '1,2d' $spike_in_reads/spike_in_reads.txt
awk '{sum += $2}END{print sum}' $spike_in_reads/spike_in_reads.txt > $spike_in_reads/spike_in_reads2.txt
counts=`head $spike_in_reads/spike_in_reads2.txt | awk -F ' ' '{print $1}'`
icpm_sample1=`awk "BEGIN {print (1/($counts/1000000))}"`



#This defines scaling factor
factor=`head $imfiles/L_counts.txt | awk -F ' ' '{print $1}'` 
#counts=`head counts/"$bam_file"_count.txt | awk -F ' ' '{print $1}'`
echo "counts="$factor
icpm=`awk "BEGIN {print (1/($factor/1000000))}"`


awk '{sum += $2}END{print sum}' $imfiles/L_TOTAL.txt > $imfiles/L_counts.txt

#This defines scaling factor
factor=`head $imfiles/L_counts.txt | awk -F ' ' '{print $1}'` 
#counts=`head counts/"$bam_file"_count.txt | awk -F ' ' '{print $1}'`
echo "counts="$factor
icpm=`awk "BEGIN {print (1/($factor/1000000))}"`




#use bamCoverage to convert size filtered bam to spike-in normalized bigwig files
bamCoverage --bam $bams/sample1_mouse_1_120.bam –scaleFactors $icpm_sample1 -o $bws/sample1_mouse_1_120.bw 

#Use spike-in normalized bigwigs to generate intermediate Matrix files with computeMatrix. 
#This provided script can be used to generate a matrix with values centered on TSSs with -0.5kb upstream and +2kb downstream
#see computeMatrix documentation for alternative uses/arguments
computeMatrix reference-point -R $bed/annotation_file.bed -S $bws/sample1_mouse_1_120.bw -o $mats/sample1_sample_1_120.mat \
--referencePoint TSS -b 2000 -a 2000 bs 20

#Use plotHeatmap to create a heatmap and metaplot from matrix files.
#This script can be used to generate a heatmap, metaplot, and associated color bars with max +3 and min -3 formatted as a png file.
#see plotHeatmap documentation for alternative uses/arguments
plotHeatmap -m $mats/sample1_mouse_1_120.mat --zMin -3 --zMax 3 --colorMap 'seismic' \
--whatToShow 'plot, heatmap and colorbar' --outFileName $plots/sample1_mouse_1_120.png

rm $spike_in_reads/$spike_in_reads/spike_in_reads.txt

