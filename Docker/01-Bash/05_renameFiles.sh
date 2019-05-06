#!/bin/bash

#SET VARIABLES---------------------------------------------------------------------
rawsampleFolder=/home/data/00_Rawdata
inputFolder=/home/data/04_SPAdes
ouputFolder=/home/data/05_inputPathogenWatch/;
#----------------------------------------------------------------------------------

#CREATE SAMPLELIST------------------------------------------------------------------------------------------
ls -a ${rawsampleFolder} > Samplelist.txt;
sed 's/_L001_R1_001.fastq.gz//g' Samplelist.txt > SamplelistII.txt;
sed 's/_L001_R2_001.fastq.gz//g' SamplelistII.txt > SamplelistIII.txt; 
#Only keep the unique strings:
uniq -d SamplelistIII.txt > sampleList.txt; 
#Remove old samplelists:
rm Samplelist.txt;
rm SamplelistII.txt;
rm SamplelistIII.txt;
#-----------------------------------------------------------------------------------------------------------

mkdir -p ${outputFolder}

for i in `cat sampleList.txt`; do
	cd ${inputFolder}
	mv contigs.fasta ${i}.fasta
	cp ${i}.fasta ${outputFolder}
done


