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
 - MiniConda: https://docs.conda.io/en/latest/miniconda.html
 - snakemake: 
      1) open a terminal
      2) execute: "conda install -c bioconda -c conda-forge snakemake"

### Windows
 - docker: https://docs.docker.com/toolbox/overview/
 - python3: https://www.python.org/downloads/
 - MiniConda: https://docs.conda.io/en/latest/miniconda.html
 - snakemake: 
      1) open anaconda terminal
      2) execute: "conda install -c bioconda -c conda-forge snakemake"
 
## Pipeline
### Preformed steps
The Pipline is controlled by Snakemake using the Snakefile found in this repository. Snakemake will read the rules specified in this file and chain them togheter in the correct order for the analysis (don't change this file unless you know what you are doing, one little change can break the entire pipeline). 

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

    Parent folder
      |-- Snakefile
      |-- .snakemake
      |     |-- log
      |          |-- log of current analysis
      |-- data
            |-- 00_Rawdata
            |        |-- sample1.fastq.gz
            |        |-- sample2.fastq.gz
            |-- 01_QC-Rawdata
            |        |-- QC_fastqc
            |        |-- QC_MultiQC
            |-- 02_Trimmomatic
            |        |--sample1_U.gz
            |        |--sample1_P.gz
            |-- 03_QC-Trimmomatic_Paired
            |        |-- QC_fastqc
            |        |-- QC_MultiQC     
            |-- 04_SPAdes
                     |-- sapmle1
                     |      |--
                     |-- sample2
                            |--

usefull commands:
  - to build containers out of the image-files (dockerfiles): $docker build --tag "imagename":"version" .
  - to run the created image: $ docker run "imagename":"version"
