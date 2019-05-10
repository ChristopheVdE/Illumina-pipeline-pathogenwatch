#!/bin/bash

###################################################################################
#NAME SCRIPT: 01_copy_rawdata.sh
#AUTHOR: Christophe Van den Eynde  
#copying rawdata to the current analysis data folders
#USAGE: ./01_copy_rawdata.sh ${input} ${output}
###################################################################################

#Fix possible EOL errors in sampleList.txt
dos2unix /home/Pipeline/data/sampleList.txt

# copy the 00_Rawdata into the current analysis folder
echo -e "\nCopying files, please wait"
for id in `cat /home/Pipeline/data/sampleList.txt`; do
    mkdir -p /home/Pipeline/data/${id}/00_Rawdata
    cp -vr /home/rawdata/${id}* /home/Pipeline/data/${id}/00_Rawdata/ \
    2>&1 | tee -a /home/Pipeline/data/${id}/00_Rawdata/stdout.txt
done    
echo -e "Done\n"