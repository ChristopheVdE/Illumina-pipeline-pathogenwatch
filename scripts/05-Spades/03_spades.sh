#!/bin/bash

###################################################################################
#NAME SCRIPT: 03_spades.sh
#AUTHOR: Tessa de Block
#DOCKER UPDATE: Christophe Van den Eynde
#ASSEMBLING READS WITH SPADES
#USAGE: ./03_SPADES.SH <number of threads> 
###################################################################################

#VALIDATE NR OF PARAMETERS---------------------------------------------------------
	# Treads are provided by snakemake
#----------------------------------------------------------------------------------

#Fix possible EOL errors in sampleList.txt
dos2unix /home/data/sampleList.txt

#RUNNING SPADES--------------------------------------------------------------------
for id in `cat /home/data/sampleList.txt`; do
	#SPECIFY VARIABLES
	inputSpades=/home/data/${id}/02_Trimmomatic
	outputSpades=/home/data/${id}/04_Spades
	outputPathwatch=/home/data/${id}/05_inputPathogenWatch

	#CREATE OUTPUTFOLDERS
	mkdir -p ${outputSpades}
	mkdir -p ${outputPathwatch}

	#CREATE temp folder-content-list
	ls /home/data/${id}/02_Trimmomatic > /home/foldercontent.txt
	sed 's/_L001_R1_001.fastq.gz//g' /home/foldercontent.txt > /home/foldercontent2.txt
	sed 's/_L001_R2_001.fastq.gz//g' /home/foldercontent2.txt > /home/foldercontent3.txt
	uniq -d /home/foldercontent3.txt > /home/foldercontent4.txt; 

	#RUN SPADES AND RENAME
	for i in `cat /home/foldercontent4.txt`; do
		#START SPADES
		echo -e "STARTING ${i} \n";	
		/SPAdes-3.13.1-Linux/bin/spades.py --pe1-1 ${inputFolder}/${i}_L001_R1_001_P.fastq.gz \
		--pe1-2 ${inputFolder}/${i}_L001_R2_001_P.fastq.gz \
		--tmp-dir /home/SPades/temp/ \
		-o ${outputSpades};
		#RENAME AND MOVE RESULTS
		cd ${outputSpades}
		cp contigs.fasta ${outputPathwatch}/${i}.fasta
	done
done

	