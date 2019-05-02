#!/bin/bash

############################################################################################################
#NAME SCRIPT: runFastqc.sh
#AUTHOR: Tessa de Block
#RUNNING FASTQC
#USAGE: ./runFastqc.sh <number of threads>
############################################################################################################


#VALIDATE NR OF PARAMETERS----------------------------------------------------------------------------------
	# parameters are provided by snakefile (hardcoded)
#-----------------------------------------------------------------------------------------------------------

#SET VARIABLES----------------------------------------------------------------------------------------------
#THREADS = specified by $snakemake -j
inputFolder= ~/data/00_Rawdata
outputFolder= ~/data/01_QC-Rawdata/QC_fastqc;
#-----------------------------------------------------------------------------------------------------------

#FASTQC PRE-START-------------------------------------------------------------------------------------------
#CREATE OUTPUTFOLDER IF NOT EXISTS
mkdir -p ${outputFolder};
#REDIRECT OUPUT COMMANDLINE (STDOUT) AND ERRORS (STDERR) INTO FILE
exec &> ${outputFolder}/stdout_err.txt;
#-----------------------------------------------------------------------------------------------------------


#RUN FASTQC-------------------------------------------------------------------------------------------------
for i in $( ls ${inputFolder} | grep fastq.gz); do
	echo -e "STARTING ${id} \n";
	fastqc --extract -t ${THREADS} -o ${outputFolder} ${inputFolder}/${i};
	echo -e "\n ${id} FINISHED \n";
done	
#-----------------------------------------------------------------------------------------------------------


