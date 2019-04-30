# ask for input directory
origin = input("Input the full path/location of the folder with the raw-data to be analysed:\n")

# creating sample-list (has file extensions)
import os
samples_ext = os.listdir(origin)

#removing file extensions for samples_ext
samples = []
for sample_ext in samples_ext:
        samples.append(sample_ext.replace('.fastq.gz', ''))

#--------------------------------------------------------------------------

rule all:
    input:
        "directory(data/01_QC01-Rawdata/MultiQC)"
        #"directory(data/02_Trimming/*)",
        #"directory(data/03_QC02-Trimmed/*)",
        #"directory(data/04_SPAdes/*)"

#--------------------------------------------------------------------------
# Pipeline step1: copying files from original raw data folder to data-folder of current analysis

rule copy_files:
    input: 
        expand(origin+"/{sample_ext}",sample_ext=samples_ext)
    output:
        expand("data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)
    message:
        "Please wait while the files are being copied"
    shell:
        "mkdir -p data/00_Rawdata/ && \
        cp {origin}/* data/00_Rawdata/"
    
#--------------------------------------------------------------------------
# Pipeline step2: running fastqc on the raw-data in the current-analysis folder

rule fastqc_raw:
    input:
        expand("data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)
    output:
        expand("data/01_QC-rawdata/QC_fastqc/{sample}_fastq.html",sample=samples)
    message:
        "Analyzing raw-data with FastQC using Docker-container fastqc:1.2"
    shell:
        #"docker run fastqc:1.1 -v ./data/:~/data/"
        "docker run -it --mount src=`pwd`/data,target=/home/data/,type=bind fastqc:1.2 /home/Scripts/QC01_fastqcRawData.sh"

#--------------------------------------------------------------------------
# Pipeline step3: running multiqc on the raw-data in the current-analysis folder

rule multiqc_raw:
    input:
        expand("data/01_QC-rawdata/QC_fastqc/{sample}_fastq.html",sample=samples)
    output:
        "directory(data/01_QC01-Rawdata/MultiQC)"
    message:
        "Analyzing raw-data with MultiQC using Docker-container multiqc:1.0"
    #docker:
    #    "docker://christophevde/multiqc:1.0"
    script:
        "scripts/QC01_multiqc.sh"
               
# /media/sf_Courses/BIT11-Stage/Data/Fastq
