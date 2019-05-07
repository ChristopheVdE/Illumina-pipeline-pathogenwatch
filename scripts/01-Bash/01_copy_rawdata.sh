#!/bin/bash

###################################################################################
#NAME SCRIPT: 01_copy_rawdata.sh
#AUTHOR: Christophe Van den Eynde  
#copying rawdata to the current analysis data folders
#USAGE: ./01_copy_rawdata.sh ${input} ${output}
###################################################################################

# copy the 00_Rawdata into the current analysis folder
echo -e "\nCopying files, please wait"
mkdir -p /home/Pipeline/data/00_Rawdata
cp -vr /home/rawdata/* /home/Pipeline/data/00_Rawdata/
echo -e "Done\n"