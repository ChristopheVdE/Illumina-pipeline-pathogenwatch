# Docker

## Introduction
Containerised analysis pipeline for Salmonella thypi using Docker containers and the Snakemake tool.

## Requirements
To run the pipeline the following programs are required. The required installation files can be found in the installer-folder provided in this repository.

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
the resulting file structure should look like this:

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
  - to run the created image: $ docker run -it --rm "imagename":"version" "command"
