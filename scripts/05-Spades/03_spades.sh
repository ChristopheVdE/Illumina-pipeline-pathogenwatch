#!/bin/bash

###################################################################################
#NAME SCRIPT: 03_spades.sh
#AUTHOR: Tessa de Block
#ASSEMBLING READS WITH SPADES
#USAGE: ./03_SPADES.SH <number of threads> 
###################################################################################

#VALIDATE NR OF PARAMETERS---------------------------------------------------------
	# parameters are provided by snakefile (hardcoded)
#----------------------------------------------------------------------------------

#SET VARIABLES---------------------------------------------------------------------
	#THREADS = $1 --> specified by $snakemake -j
rawsampleFolder=/home/data/00_Rawdata
inputFolder=/home/data/02_Trimmomatic
ouputFolder=/home/data/04_Spades;
#----------------------------------------------------------------------------------

#CREATE SAMPLELIST-----------------------------------------------------------------
ls -a ${rawsampleFolder} > Samplelist.txt;
sed 's/_L001_R1_001.fastq.gz//g' Samplelist.txt > SamplelistII.txt;
sed 's/_L001_R2_001.fastq.gz//g' SamplelistII.txt > SamplelistIII.txt; 
#Only keep the unique strings:
uniq -d SamplelistIII.txt > sampleList.txt; 
#Remove old samplelists:
rm Samplelist.txt;
rm SamplelistII.txt;
rm SamplelistIII.txt;
#----------------------------------------------------------------------------------

#CREATE OUTPUTFOLDER IF NOT EXISTS------------------------------------------------- 
mkdir -p ${ouputFolder};
#----------------------------------------------------------------------------------

#RUNNING SPADES--------------------------------------------------------------------
for i in `cat sampleList.txt`; do
	echo -e "STARTING ${i} \n";	
	/SPAdes-3.13.1-Linux/bin/spades.py --pe1-1 ${inputFolder}/${i}_L001_R1_001_P.fastq.gz \
	--pe1-2 ${inputFolder}/${i}_L001_R2_001_P.fastq.gz \
	--tmp-dir /home/SPades/temp/ \
	-o ${ouputFolder}/${i}; \ 
done
#----------------------------------------------------------------------------------
	

	