#!/bin/bash

###################################################################################
#NAME SCRIPT: 03_spades.sh
#AUTHOR: Tessa de Block
#ASSEMBLING READS WITH SPADES
#USAGE: ./03_SPADES.SH <number of threads> 
###################################################################################


#VALIDATE NR OF PARAMETERS---------------------------------------------------------
function usage() {
	errorcode=" \nERROR -> This script needs 1 parameters:\n
		1: number of threads\n";
				
	echo -e ${errorcode};
	exit 1;
}
if [ "$#" -ne 1 ]; then
	usage
fi
#----------------------------------------------------------------------------------


#SET VARIABLES---------------------------------------------------------------------
THREADS=$1;
ouputFolder=../02_spades;
#----------------------------------------------------------------------------------


#CREATE OUTPUTFOLDER IF NOT EXISTS------------------------------------------------- 
mkdir -p ${ouputFolder};
#----------------------------------------------------------------------------------


#RUNNING SPADES--------------------------------------------------------------------
for i in `cat sampleList.txt`; do
	echo -e "STARTING ${i} \n";	
	spades.py --pe1-1 ../01_trimmomatic/${i}_L001_R1_001_P.fastq.gz \
	--pe1-2 ../01_trimmomatic/${i}_L001_R2_001_P.fastq.gz \
	-o ${ouputFolder}/${i} -t ${THREADS};
done
#----------------------------------------------------------------------------------
	

	