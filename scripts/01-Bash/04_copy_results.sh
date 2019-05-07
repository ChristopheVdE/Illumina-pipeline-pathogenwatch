#!/bin/bash

###################################################################################
#NAME SCRIPT: 04_copy_results.sh
#AUTHOR:  
#rename results and copy them back to the original rawdata folder
#USAGE: ./04_copy_results.sh ${input} ${output}
###################################################################################

#COPY results----------------------------------------------------------------------
# copy the rawdata-files to the 'current analysis data-folder'
echo -e "\nCopying files, please wait"
# copy the 00_Rawdata into the current analysis folder
cp -vrn /home/Pipeline/data/* /home/rawdata/00_Rawdata/ 
echo -e "Done\n"
#----------------------------------------------------------------------------------