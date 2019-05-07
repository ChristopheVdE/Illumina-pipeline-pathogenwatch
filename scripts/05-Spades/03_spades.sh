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
inputSpades=/home/data/02_Trimmomatic
outputSpades=/home/data/04_Spades
outputPathwatch=/home/data/05_inputPathogenWatch
sampleList=/home/data/sampleList.txt
#----------------------------------------------------------------------------------

#============================
# Part1: Spades
#============================

#CREATE OUTPUTFOLDER IF NOT EXISTS------------------------------------------------- 
mkdir -p ${outputSpades};
#----------------------------------------------------------------------------------

#RUNNING SPADES--------------------------------------------------------------------
for i in `cat ${sampleList}`; do
	echo -e "STARTING ${i} \n";	
	/SPAdes-3.13.1-Linux/bin/spades.py --pe1-1 ${inputFolder}/${i}_L001_R1_001_P.fastq.gz \
	--pe1-2 ${inputFolder}/${i}_L001_R2_001_P.fastq.gz \
	--tmp-dir /home/SPades/temp/ \
	-o ${outputSpades}/${i}; 
done
#----------------------------------------------------------------------------------

#============================
# Part2: Input pathogenwatch
#============================

#RENAME RESULTS-----------------------------------------------------------------
mkdir -p ${outputPathwatch}

for i in `cat ${sampleList}`; do
	cd ${outputSpades}/${i}
	mv contigs.fasta ${i}.fasta
	cp ${i}.fasta ${outputPathwatch}
done
#----------------------------------------------------------------------------------

	