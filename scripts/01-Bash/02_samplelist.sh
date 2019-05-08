#!/bin/bash

###################################################################################
#NAME SCRIPT: 04_copy_results.sh
#AUTHOR:  
#rename results and copy them back to the original rawdata folder
#USAGE: ./04_copy_results.sh ${input} ${output}
###################################################################################

#SET VARIABLES---------------------------------------------------------------------
rawsampleFolder=/home/data/00_Rawdata
ouputFolder=/home/data/
#----------------------------------------------------------------------------------

#CREATE SAMPLELIST-----------------------------------------------------------------
ls -a ${rawsampleFolder} > ${outputFolder}/Samplelist.txt;
sed 's/_L001_R1_001.fastq.gz//g' ${outputFolder}/Samplelist.txt > ${outputFolder}/SamplelistII.txt;
sed 's/_L001_R2_001.fastq.gz//g' ${outputFolder}/SamplelistII.txt > ${outputFolder}/SamplelistIII.txt; 
#Only keep the unique strings:
uniq -d ${outputFolder}/SamplelistIII.txt > ${outputFolder}/sampleList.txt; 
#Remove old samplelists:
rm ${outputFolder}/Samplelist.txt;
rm ${outputFolder}/SamplelistII.txt;
rm ${outputFolder}/SamplelistIII.txt;
#----------------------------------------------------------------------------------