#!/bin/bash

###################################################################################
#NAME SCRIPT: 01_copy_rawdata.sh
#AUTHOR: Christophe VAn den Eynde  
#copying rawdata to the current analysis data folders
#USAGE: ./01_copy_rawdata.sh ${input} ${output}
###################################################################################

# copy the rawdata-files to the 'current analysis data-folder'
echo -e "\nCopying files, please wait"
mkdir -p /home/Pipeline/data/00_Rawdata
cp /home/rawdata/* /home/Pipeline/data/00_Rawdata/
echo -e "Done\n"