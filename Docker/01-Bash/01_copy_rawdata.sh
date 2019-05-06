#!/bin/bash

###################################################################################
#NAME SCRIPT: 01_copy_rawdata.sh
#AUTHOR: Christophe Van den Eynde  
#copying rawdata to the current analysis data folders
#USAGE: ./01_copy_rawdata.sh ${input} ${output}
###################################################################################

# copy the rawdata-files to the 'current analysis data-folder'
echo -e "\nCopying files, please wait"
    # put the rawdata into the correct file-structure 
mv /home/rawdata/* /home/rawdata/00_Rawdata/
    # copy the 00_Rawdata into the current analysis folder
mkdir -p /home/Pipeline/data/00_Rawdata
cp -vr /home/rawdata/00_Rawdata/ /home/Pipeline/data/00_Rawdata/
echo -e "Done\n"