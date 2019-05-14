# Docker
*this readme can also be found as a word document with some more in-depth instructions when required in the info-folder* 

## Introduction
Containerised analysis pipeline for Salmonella thypi using Docker containers and the Snakemake tool.

## Requirements
To run the pipeline the following programs are required.

### Linux
 - docker: 
      - CentOS: https://docs.docker.com/install/linux/docker-ce/centos/
      - Ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/
      - Debian: https://docs.docker.com/install/linux/docker-ce/debian/
      - Fedora: https://docs.docker.com/install/linux/docker-ce/fedora/
 - python3:
      1) open terminal
      2) execute: *'syntax to download packages'* pyhton3

### Windows
 - docker: https://docs.docker.com/toolbox/overview/
 - python3: https://www.python.org/downloads/
 
## Pipeline
### Starting the pipeline
In Order to start the pipeline you only really need 1 file ("get_environment.py") provided in this repository which you can execute through the command line. For those not familliar with a command line interface, there are 2 'auto-run scripts' provided, one for Windows users and one for Linux users:

- For Linux users: LINUX_run-pipeline.sh
- For Windows users: WINDOWS_run-pipeline.cmd

These scripts can be ativated by double clicking on them, after which each of them should ask for the location of the rawdata. These locations can easily be found by opening an explorer, navigating to the files and copying the path from there (most of the time the path will be displayed at the top of the screen). Please make sure that there are no spaces in the path to these locations.
After the path is provided the script will automatically execute all the required steps without any user input. When the analysis is complete you will get message displayed in the command line indicating this. together with this message, the time it took to complete the analysis will be displayed.

The other files found in this repository are the codes used to create the Docker images for the containers and the scripts that are loaded into these containers. You don't need these since the containers will automatically be downloaded and 'installed' when the pipeline is ran for the first time (download from Docker-HUB).

### Preformed steps
The Pipline is controlled by Snakemake, which itself is being ran in a container. Snakemake will read the rules/steps specified in the Snakefile and chain them togheter in the correct order for the analysis. 

Snakemake will preform the following steps durig the analysis. Each step is specified as a rule in the Snakefile and will be executed in a docker container created for that specific task:

    0) copying files for  original location to the current-analysis folder (data/)
    1) QC on raw data using FastQC
    2) QC on raw data using MultiQC
    2) Trimmomatic
    3) QC on trimmed data using FastQC
    4) QC on trimmed data usisg MultiQC
    4) Spades
    5) File renaming
    6) Use results in Pathogenwatch.com (manual step)
  
### Results
the resulting file structure should look like this, with all rawdata and analysis data grouped per sample. To make revieuwing the QC a bit easier, the MultiQC results for the full run (all samples) are stored sepparatly under QC-MultiQC/date. The full log of the snakemake program can be found under Snakemake_logs.

      data
       |--Sample1
       |     |-- 00_Rawdata
       |     |-- 01_QC-Rawdata
       |     |        |-- QC_fastqc
       |     |        |-- QC_MultiQC (multiqc of only this sample)
       |     |-- 02_Trimmomatic
       |     |        |--sample1_U.gz
       |     |        |--sample1_P.gz
       |     |-- 03_QC-Trimmomatic_Paired
       |     |        |-- QC_fastqc
       |     |        |-- QC_MultiQC (multiqc of only this sample)
       |     |-- 04_SPAdes
       |     |-- 05_inputPathogenWatch
       |--Sample2
       |--QC_MultiQC (MultiQC of all samples in the run combined)
       |     |--RUN_date
       |          |--MultiQC_rawdata
       |          |--MultiQC_trimmed
       |--Snakemake_logs
        
## Usefull commands:
  - to build containers out of the image-files (dockerfiles): $docker build --tag="imagename":"version" .
  - to run the created image: $docker run -it --rm "imagename":"version" "command"
  - to list all Docker images found on the host: $docker image ls
  - to list all container currently running on the host: $docker container ls
  - to remove a Docker image from the host: $docker image rm "imagename":"version"
