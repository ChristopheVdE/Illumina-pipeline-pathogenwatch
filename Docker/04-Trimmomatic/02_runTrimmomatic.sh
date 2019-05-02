#!/bin/bash

############################################################################################################
#NAME SCRIPT: runTrimmomatic.sh
#AUTHOR: Tessa de Block
#RUNNING TRIMMOMATIC
#USAGE: ./runTrimmomatic.sh <number of threads>
############################################################################################################


#VALIDATE NR OF PARAMETERS----------------------------------------------------------------------------------
	# parameters are provided by snakefile (hardcoded)
#-----------------------------------------------------------------------------------------------------------

#SET VARIABLES----------------------------------------------------------------------------------------------
	#THREADS = specified by $snakemake -j
inputFolder=/home/data/00_Rawdata
outputFolder=/home/data/02_Trimmomatic
ADAPTERFILE='/home/adapters/NexteraPE-PE.fa';
#-----------------------------------------------------------------------------------------------------------


#CREATE SAMPLELIST------------------------------------------------------------------------------------------
ls -a ${inputFolder} > Samplelist.txt;
sed 's/_L001_R1_001.fastq.gz//g' Samplelist.txt > SamplelistII.txt;
sed 's/_L001_R2_001.fastq.gz//g' SamplelistII.txt > SamplelistIII.txt; 
#Only keep the unique strings:
uniq -d SamplelistIII.txt > sampleList.txt; 
#Remove old samplelists:
rm Samplelist.txt;
rm SamplelistII.txt;
rm SamplelistIII.txt;
#-----------------------------------------------------------------------------------------------------------

#TRIMMOMATIC PRE-START--------------------------------------------------------------------------------------
#CREATE OUTPUTFOLDER IF NOT EXISTS
mkdir -p ${outputFolder};
#REDIRECT OUPUT COMMANDLINE (STDOUT) AND ERRORS (STDERR) INTO FILE
exec 2>&1 | tee ${outputFolder}/stdout_err.txt;
#-----------------------------------------------------------------------------------------------------------

#RUN TRIMMOMATIC--------------------------------------------------------------------------------------------
for i in `cat sampleList.txt`; do
	echo -e "STARTING ${i} \n";
	java -jar /home/Trimmomatic-0.39/trimmomatic-0.39.jar  \
	PE -phred33 -trimlog ${outputFolder}/trimlog.txt \
	${inputFolder}/${i}_L001_R1_001.fastq.gz ${inputFolder}/${i}_L001_R2_001.fastq.gz \
	${outputFolder}/${i}_L001_R1_001_P.fastq.gz ${outputFolder}/${i}_L001_R1_001_U.fastq.gz \
	${outputFolder}/${i}_L001_R2_001_P.fastq.gz ${outputFolder}/${i}_L001_R2_001_U.fastq.gz \
	ILLUMINACLIP:${ADAPTERFILE}:2:40:15 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:36;
done
#-----------------------------------------------------------------------------------------------------------
	