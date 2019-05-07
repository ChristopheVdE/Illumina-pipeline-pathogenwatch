#!/bin/bash

###################################################################################
#NAME SCRIPT: 04_copy_results.sh
#AUTHOR:  
#rename results and copy them back to the original rawdata folder
#USAGE: ./04_copy_results.sh ${input} ${output}
###################################################################################

#SET VARIABLES---------------------------------------------------------------------
rawsampleFolder=/home/data/00_Rawdata
inputFolder=/home/data/04_SPAdes
ouputFolder=/home/data/05_inputPathogenWatch/;
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

#RENAME RESULTS-----------------------------------------------------------------
mkdir -p ${outputFolder}

for i in `cat sampleList.txt`; do
	cd ${inputFolder}
	mv contigs.fasta ${i}.fasta
	cp ${i}.fasta ${outputFolder}
done
#----------------------------------------------------------------------------------

#COPY results----------------------------------------------------------------------
# copy the rawdata-files to the 'current analysis data-folder'
echo -e "\nCopying files, please wait"
# copy the 00_Rawdata into the current analysis folder
cp -vrn /home/Pipeline/data/* /home/rawdata/00_Rawdata/ 
echo -e "Done\n"
#----------------------------------------------------------------------------------