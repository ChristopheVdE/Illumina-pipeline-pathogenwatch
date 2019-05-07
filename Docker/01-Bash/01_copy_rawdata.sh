#!/bin/bash

###################################################################################
#NAME SCRIPT: 01_copy_rawdata.sh
#AUTHOR: Christophe Van den Eynde  
#copying rawdata to the current analysis data folders
#USAGE: ./01_copy_rawdata.sh ${input} ${output}
###################################################################################

# put the rawdata into the correct file-structure 
    #(used for final step in the pipeline: copying results back to original data location)
echo -e "\nCreating correct file structure" 
mkdir -p /home/rawdata/00_Rawdata/
mv -v /home/rawdata/*.fastq.gz /home/rawdata/00_Rawdata/
echo -e "Done"

# copy the 00_Rawdata into the current analysis folder
echo -e "\nCopying files, please wait"
mkdir -p /home/Pipeline/data/00_Rawdata
cp -vr /home/rawdata/00_Rawdata/* /home/Pipeline/data/00_Rawdata/
echo -e "Done\n"