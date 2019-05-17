#!/bin/bash

###################################################################################
#NAME SCRIPT: Snakemake_Linux.sh
#AUTHOR: Christophe Van den Eynde  
#specifies the number of threads to use and executes the snakemake command
#USAGE: ./Snakemake_Linux.sh
###################################################################################

# Starting snakemake
echo "\nStarting snakemake"
python3 ./get_environment.py
echo "done"
# echo "Done\n"