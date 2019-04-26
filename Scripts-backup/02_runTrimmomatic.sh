#!/bin/bash

############################################################################################################
#NAME SCRIPT: runTrimmomatic.sh
#AUTHOR: Tessa de Block
#RUNNING TRIMMOMATIC
#USAGE: ./runTrimmomatic.sh <number of threads>
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
ADAPTERFILE='/home/linuxbrew/.linuxbrew/Cellar/trimmomatic/0.38/share/trimmomatic/adapters/NexteraPE-PE.fa';
#-----------------------------------------------------------------------------------------------------------


#CREATE SAMPLELIST------------------------------------------------------------------------------------------
ls -a ../00_dataset > Samplelist.txt;
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
mkdir -p ../01_trimmomatic;
#REDIRECT OUPUT COMMANDLINE (STDOUT) AND ERRORS (STDERR) INTO FILE
exec &> ../01_trimmomatic/stdout_err.txt;
#-----------------------------------------------------------------------------------------------------------

#RUN TRIMMOMATIC--------------------------------------------------------------------------------------------
for i in `cat sampleList.txt`; do
echo -e "STARTING ${i} \n";
java -jar /home/linuxbrew/.linuxbrew/Cellar/trimmomatic/0.38/libexec/trimmomatic-0.38.jar  \
PE -threads ${THREADS} -phred33 -trimlog ../01_trimmomatic/trimlog.txt \
../00_dataset/${i}_L001_R1_001.fastq.gz ../00_dataset/${i}_L001_R2_001.fastq.gz \
../01_trimmomatic/${i}_L001_R1_001_P.fastq.gz ../01_trimmomatic/${i}_L001_R1_001_U.fastq.gz \
../01_trimmomatic/${i}_L001_R2_001_P.fastq.gz ../01_trimmomatic/${i}_L001_R2_001_U.fastq.gz \
ILLUMINACLIP:${ADAPTERFILE}:2:40:15 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:36;
done
#-----------------------------------------------------------------------------------------------------------
	