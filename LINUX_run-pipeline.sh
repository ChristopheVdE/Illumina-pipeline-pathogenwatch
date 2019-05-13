#!/bin/bash

###################################################################################
#NAME SCRIPT: Snakemake_Linux.sh
#AUTHOR: Christophe Van den Eynde  
#specifies the number of threads to use and executes the snakemake command
#USAGE: ./Snakemake_Linux.sh
###################################################################################

# Counting treads
# Treads=`nproc --all`
# # specifying the number of threads snakemake can use
# if ${Treads} -le 4; then 
#     s_Treads=$((${Treads}/2))
# else
#     s_Treads=$((${Treads}/4*3))
# fi 

# echo "${Treads} treads found, reserving ${s_Treads} treads for snakemake"

# Starting snakemake
echo "\nStarting snakemake"
pyhton3 ./get_environment.py
echo "done"
# echo "Done\n"