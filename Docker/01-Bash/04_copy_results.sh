#!/bin/bash

###################################################################################
#NAME SCRIPT: 04_copy_results.sh
#AUTHOR: Christophe Van den Eynde  
#copying rawdata to the current analysis data folders
#USAGE: ./04_copy_results.sh ${input} ${output}
###################################################################################

# copy the rawdata-files to the 'current analysis data-folder'
echo -e "\nCopying files, please wait"
# copy the 00_Rawdata into the current analysis folder
cp -vrn /home/Pipeline/data/* /home/rawdata/00_Rawdata/ 
echo -e "Done\n"