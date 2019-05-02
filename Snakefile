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
        #"directory(data/01_QC02-Trimmed/MultiQC)"
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
        "docker run -it --mount src={origin},target=/home/rawdata/,type=bind --mount src=`pwd`,target=/home/Pipeline/,type=bind ubuntu:18.04 /home/Pipeline/scripts/01_copy_rawdata.sh"
    
#--------------------------------------------------------------------------
# Pipeline step2: running fastqc on the raw-data in the current-analysis folder

rule fastqc_raw:
    input:
        expand("data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)
    output:
        expand("data/01_QC-rawdata/QC_fastqc/{sample}_fastqc.html",sample=samples)
    message:
        "Analyzing raw-data with FastQC using Docker-container fastqc:1.3"
    shell:
        "docker run -it --mount src=`pwd`/data,target=/home/data/,type=bind fastqc:1.3 /home/Scripts/QC01_fastqcRawData.sh"

#--------------------------------------------------------------------------
# Pipeline step3: running multiqc on the raw-data in the current-analysis folder

rule multiqc_raw:
    input:
        expand("data/01_QC-rawdata/QC_fastqc/{sample}_fastqc.html",sample=samples)
    output:
        "directory(data/01_QC01-Rawdata/MultiQC)"
    message:
        "Analyzing raw-data with MultiQC using Docker-container multiqc:1.0"
    shell:
        "docker run -it --mount src=`pwd`/data,target=/home/data/,type=bind multiqc:1.0 /home/Scripts/QC01_multiqc.sh"

#--------------------------------------------------------------------------
# Pipeline step5: Trimming

#--------------------------------------------------------------------------
# Pipeline step5: FastQC trimmed data

#--------------------------------------------------------------------------
# Pipeline step6: MultiQC trimmed data

#--------------------------------------------------------------------------
# Pipeline step7: Spades

# /media/sf_Courses/BIT11-Stage/Data/Fastq
