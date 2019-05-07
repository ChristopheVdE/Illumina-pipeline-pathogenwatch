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
inputFolder=/home/data/02_Trimmomatic
outputFolder=/home/data/03_QC-Trimmomatic_Paired/QC_fastqc;
#-----------------------------------------------------------------------------------------------------------

#FASTQC PRE-START-------------------------------------------------------------------------------------------
#CREATE OUTPUTFOLDER IF NOT EXISTS
mkdir -p ${outputFolder};
#REDIRECT OUPUT COMMANDLINE (STDOUT) AND ERRORS (STDERR) INTO FILE
exec 2>&1 | tee ${outputFolder}/stdout_err.txt;
#-----------------------------------------------------------------------------------------------------------


#RUN FASTQC on Paired end reads-----------------------------------------------------------------------------
for i in $(ls ${inputFolder} | grep _P.fastq.gz); do
     echo -e "STARTING FastQC on paired reads of $i \n";
     fastqc --extract -o ${outputFolder} ${inputFolder}/${i};
     echo -e "\n ${id} FINISHED \n";
done	

#-----------------------------------------------------------------------------------------------------------



