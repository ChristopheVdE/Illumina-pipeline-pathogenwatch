# ask for input directory
origin = input("Input the full path/location of the folder with the raw-data to be analysed:\n")

# creating sample-list
import os
samples_ext = os.listdir(origin)

#removing file extensions for samples
samples = []
for sample in samples:
        samples.append(sample.replace('.fastq.gz', ''))

#--------------------------------------------------------------------------

rule all:
    input:
        expand("data/00_rawdata/{sample}.fastq.gz",sample=samples),
        expand("data/01_QC-rawdata/{sample}.html",sample=samples)
        #"directory(data/02_Trimming/*)",
        #"directory(data/03_QC02-Trimmed/*)",
        #"directory(data/04_SPAdes/*)"

#--------------------------------------------------------------------------

# Pipeline step1: copying files from original raw data folder to data-folder of current analysis
rule copy_files:
    input: 
        expand(origin+"/{sample}",sample=samples)
    output:
        expand("data/00_rawdata/{sample}",sample=samples)
    message:
        "Please wait while the files are being copied"
    shell:
        "cp {input} data/00_rawdata/"
    

#--------------------------------------------------------------------------

# Pipeline step2: running fastqc on the raw-data in the current-analysis folder
"input_folder = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe(data/00_rawdata))))"
"print(input_folder)"

rule fastqc:
    input:
        expand("data/00_rawdata/{sample}.fastq.gz",sample=samples)
    output:
        expand("data/01_QC-rawdata/{sample}.html",sample=samples)
    message:
        "Analyzing raw-data with FastQC using Docker-container fastqc:1.0"
    docker:
        "docker run fastqc:1.0 -v input_folder C01_fastqcRawData.sh"

#--------------------------------------------------------------------------



        
# /media/sf_Courses/BIT11-Stage/Data/Fastq
