# creating sample-list
origin = input("Input the full path/location of the folder with the raw-data to be analysed:\n")
import os
samples = os.listdir(origin)

# Pipeline step1: copying files from original raw data folder to data-folder of current analysis
rule copy_files:
    input: 
        expand(origin+"/{sample}",sample=samples)
    output:
        expand("data/00_rawdata/{sample}",sample=samples)
    message:
        "Please wait while the files are being copied"
    shell:"""
        cp {input} data/00_rawdata/
    """

# Pipeline step2: running fastqc on the raw-data in the current-analysis folder
rule fastqc:
    input:
        expand("data/00_rawdata/{sample}.fastq.gz",sample=samples)
    output:
        "data/01_QC-rawdata/"
    script:
        "QC01_fastqcRawData.sh"

rule all:
    input:
        "directory(data/00_rawdata)",
        "directory(data/01_QC-rawdata)",
        "directory(data/02_Trimming)",
        "directory(data/03_QC02-Trimmed)",
        "directory(data/04_SPAdes)"

        
# /media/sf_Courses/BIT11-Stage/Data/Fastq
