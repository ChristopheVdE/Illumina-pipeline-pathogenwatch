#!/bin/bash

############################################################################################################
#NAME SCRIPT: runTrimmomatic.sh
#AUTHOR: Tessa de Block
#DOCKER UPDATE: Christophe Van den Eynde
#RUNNING TRIMMOMATIC
#USAGE: ./runTrimmomatic.sh <number of threads>
############################################################################################################

#VARIABLES--------------------------------------------------------------------------------------------------
# inputFolder = /home/data/${id}/00_Rawdata
# outputFolder = /home/data/${id}/02_Trimmomatic
#-----------------------------------------------------------------------------------------------------------

#TRIMMOMATIC PRE-START--------------------------------------------------------------------------------------
threads=`nproc --all`
ADAPTERFILE='/home/adapters/NexteraPE-PE.fa';
#Fix possible EOL errors in sampleList.txt
dos2unix /home/data/sampleList.txt
#-----------------------------------------------------------------------------------------------------------

#RUN TRIMMOMATIC--------------------------------------------------------------------------------------------
echo "Starting Trimmomatic with ${threads} threads"
for id in `cat /home/data/sampleList.txt`; do
	#SPECIFY VARIABLES
	inputFolder=/home/data/${id}/00_Rawdata
	outputFolder=/home/data/${id}/02_Trimmomatic

	#CREATE OUTPUTFOLDER IF NOT EXISTS
	mkdir -p /home/data/${id}/02_Trimmomatic

	#CREATE temp folder-content-list
	ls /home/data/${id}/00_Rawdata > /home/foldercontent.txt
	sed 's/_L001_R1_001.fastq.gz//g' /home/foldercontent.txt > /home/foldercontent2.txt
	sed 's/_L001_R2_001.fastq.gz//g' /home/foldercontent2.txt > /home/foldercontent3.txt
	uniq -d /home/foldercontent3.txt > /home/foldercontent4.txt; 

	#RUN TRIMMOMATIC
	for i in `cat /home/foldercontent4.txt`; do
		echo -e "\nSTARTING ${i} \n";
		java -jar /home/Trimmomatic-0.39/trimmomatic-0.39.jar  \
		PE -threads ${threads} -phred33 -trimlog /home/data/${i}/02_Trimmomatic/trimlog.txt \
		/home/data/${i}/00_Rawdata/${i}_L001_R1_001.fastq.gz /home/data/${i}/00_Rawdata/${i}_L001_R2_001.fastq.gz \
		/home/data/${i}/02_Trimmomatic/${i}_L001_R1_001_P.fastq.gz /home/data/${i}/02_Trimmomatic/${i}_L001_R1_001_U.fastq.gz \
		/home/data/${i}/02_Trimmomatic/${i}_L001_R2_001_P.fastq.gz /home/data/${i}/02_Trimmomatic/${i}_L001_R2_001_U.fastq.gz \
		ILLUMINACLIP:${ADAPTERFILE}:2:40:15 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:36 \
		2>&1 | tee -a /home/data/${i}/02_Trimmomatic/stdout_err.txt;
	done
done
#-----------------------------------------------------------------------------------------------------------