#!/bin/bash

mkdir -p ../03_inputPathogenWatch

for i in `cat sampleList.txt`; do
	cd ../02_spades/${i}
	mv contigs.fasta ${i}.fasta
	cp ${i}.fasta ../../03_inputPathogenWatch
	cd ../../scripts;
	
done


