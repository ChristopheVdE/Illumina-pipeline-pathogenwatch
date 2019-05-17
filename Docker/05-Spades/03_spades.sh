#!/bin/bash

###################################################################################
#NAME SCRIPT: 03_spades.sh
#AUTHOR: Tessa de Block
#DOCKER UPDATE: Christophe Van den Eynde
#ASSEMBLING READS WITH SPADES
#USAGE: ./03_SPADES.SH <number of threads> 
###################################################################################

#VALIDATE NR OF PARAMETERS---------------------------------------------------------
threads=`nproc --all`
#----------------------------------------------------------------------------------

#SPECIFY VARIABLES-----------------------------------------------------------------
#inputSpades=/home/data/${id}/02_Trimmomatic
#outputSpades=/home/data/${id}/04_Spades
#outputPathwatch=/home/data/${id}/05_inputPathogenWatch
#-----------------------------------------------------------------------------------

#Fix possible EOL errors in sampleList.txt
dos2unix /home/data/sampleList.txt

#RUNNING SPADES--------------------------------------------------------------------
echo "Starting SPAdes with ${threads} threads"
for id in `cat /home/data/sampleList.txt`; do

	#CREATE OUTPUTFOLDERS
	mkdir -p /home/data/${id}/04_SPAdes
	mkdir -p /home/data/${id}/05_inputPathogenWatch

	#CREATE temp folder-content-list
	ls /home/data/${id}/02_Trimmomatic > /home/foldercontent.txt
	sed 's/_L001_R1_001_P.fastq.gz//g' /home/foldercontent.txt > /home/foldercontent2.txt
	sed 's/_L001_R1_001_U.fastq.gz//g' /home/foldercontent2.txt > /home/foldercontent3.txt
	sed 's/_L001_R2_001_P.fastq.gz//g' /home/foldercontent3.txt > /home/foldercontent4.txt
	sed 's/_L001_R1_001_U.fastq.gz//g' /home/foldercontent4.txt > /home/foldercontent5.txt
	uniq -d /home/foldercontent5.txt > /home/foldercontent6.txt; 

	#RUN SPADES AND RENAME
	for i in `cat /home/foldercontent6.txt`; do
		#START SPADES
		echo -e "\nSTARTING ${i} \n";	
		/SPAdes-3.13.1-Linux/bin/spades.py --pe1-1 /home/data/${id}/02_Trimmomatic/${id}_L001_R1_001_P.fastq.gz \
		--pe1-2 /home/data/${id}/02_Trimmomatic/${id}_L001_R2_001_P.fastq.gz \
		--tmp-dir /home/SPAdes/temp/ \
		-o /home/data/${id}/04_SPAdes -t ${threads};
		#RENAME AND MOVE RESULTS
		cd /home/data/${id}/04_SPAdes
		cp contigs.fasta /home/data/${id}/05_inputPathogenWatch/${id}.fasta
	done
done

	