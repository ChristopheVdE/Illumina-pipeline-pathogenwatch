#!/bin/bash

###################################################################################
#NAME SCRIPT: Snakemake_Linux.sh
#AUTHOR: Christophe Van den Eynde  
#specifies the number of threads to use and executes the snakemake command
#USAGE: ./Snakemake_Linux.sh
###################################################################################

# Starting snakemake
echo "\nStarting snakemake"
cd "$(dirname "$BASH_SOURCE")"
python3 ./get_environment_v2.5.py
echo "done"
# echo "Done\n"
