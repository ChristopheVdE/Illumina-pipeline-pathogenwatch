#!/bin/bash

############################################################################################################
#NAME SCRIPT: runFastqc.sh
#AUTHOR: Tessa de Block
#RUNNING FASTQC
#USAGE: ./runFastqc.sh <number of threads>
############################################################################################################


#VALIDATE NR OF PARAMETERS----------------------------------------------------------------------------------
function usage() {
	errorcode=" \nERROR -> This script need 1 parameters:\n
		1: number of threads\n"; 
		
	echo -e ${errorcode};
	exit 1;
}
if [ "$#" -ne 1 ]; then
	usage
fi
#-----------------------------------------------------------------------------------------------------------

#SET VARIABLES----------------------------------------------------------------------------------------------
THREADS=$1;
inputFolder=../01_trimmomatic
outputFolder=../01_trimmomatic/QC_fastqc;
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


