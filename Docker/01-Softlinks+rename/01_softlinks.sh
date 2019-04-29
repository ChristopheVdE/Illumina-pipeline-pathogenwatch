#!/bin/bash

###################################################################################
#NAME SCRIPT: softlinks.sh
#AUTHOR: Tessa de Block
#CREATING SOFTLINKS IN A FOLDER OF FASTQ.GZ FILES
#USAGE: ./SOFTLINKS.SH <PATH  TO DIRECTORY FASTQ.GZ FILES> 
###################################################################################


#VALIDATE NR OF PARAMETERS---------------------------------------------------------
function usage() {
	errorcode=" \nERROR -> This script needs 1 parameters:\n
		1: path to the directory with the fastq.gz files\n";
				
	echo -e ${errorcode};
	exit 1;
}
if [ "$#" -ne 1 ]; then
	usage
fi
#----------------------------------------------------------------------------------


#SET VARIABLES---------------------------------------------------------------------
inputFolder=$1;
ouputFolder=../00_dataset;
#----------------------------------------------------------------------------------


#CREATE OUTPUTFOLDER IF NOT EXISTS------------------------------------------------- 
mkdir -p ${ouputFolder};
#----------------------------------------------------------------------------------


#MAKING SOFTLINKS------------------------------------------------------------------
for i in $( ls ${inputFolder}/ | grep fastq.gz); do
ln -s ${inputFolder}${i} ${ouputFolder}/${i} ;
done
#----------------------------------------------------------------------------------
	