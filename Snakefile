############################################################################################################
#NAME:  SNAKEMAKE
#AUTHOR: Christophe Van den Eynde
#RUNNING: Salmonella t. pipeline for Illumina reads
#USAGE: $snakemake
############################################################################################################

# timer
import time
start = time.time()

# ask for input directory (origin)
import os
origin = input("\nInput the full path/location of the folder with the raw-data to be analysed.\n\
Please check wheter upper and lower case letters are correct:\n\
If using Windows: it's advised to have the rawdata on the C-drive before the analysis, otherwise there might be some problems finding the location\n")

print("\norigin={}".format(origin))

# get current directory
location = os.getcwd()
print("location={}".format(location))

# creating sample-list (has file extensions)
samples_ext = os.listdir(origin)

#removing file extensions for samples_ext
samples = []
ids =[]
for sample_ext in samples_ext:
    samples.append(sample_ext.replace('.fastq.gz', '')),
    ids.append(sample_ext.replace('_L001_R1_001.fastq.gz','').replace('_L001_R2_001.fastq.gz',''))
samples= sorted(samples)
ids = sorted(set(ids))

#create samplelist.txt
file = open(location+"/data/sampleList.txt",mode="w")
for i in ids:
    file.write(i+"\n")
file.close()

# analysis date
from datetime import datetime
run = datetime.now().strftime("%d/%m/%Y")

#find system-type
import platform
OS=platform.platform()

# fix the path if system is Windows
import string
if "Windows" in OS:
    print("\nWindows based system detected ({}), fixing paths".format(OS))
    for i in list(string.ascii_lowercase+string.ascii_uppercase):
        if origin.startswith(i+":/"):
            origin_m = origin.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif origin.startswith(i+":\\"):
            origin_m = origin.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
        if location.startswith(i+":/"):
            location_m = location.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif location.startswith(i+":\\"):
            location_m = location.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
    print("\torigin ({}) changed to: {}".format(origin,origin_m))
    print("\tlocation ({}) changed to: {}\n".format(location,location_m))
else:
    origin_m = origin
    location_m = location
    print("\nUNIX based system detected ({}), paths shouldn't require fixing".format(OS))

#--------------------------------------------------------------------------
# Pipeline last step: takes all results and copy's them back to the original rawdata folder

rule all:                                                                       
    input:
        expand(location+"/data/{id}/01_QC-Rawdata/QC_MultiQC/multiqc_report.html",id=ids),                            
        expand(location+"/data/{id}/03_QC-Trimmomatic_Paired/QC_MultiQC/multiqc_report.html",id=ids),                       
        expand(location+"/data/{id}/04_SPAdes/dataset.info",id=ids)                                             
#    output:
#        directory("{origin}/00_Rawdata"),
#        directory("{origin}/01_QC-Rawdata"),
#        directory("{origin}/02_Trimmomatic"),
#        directory("{origin}/03_QC-Trimmomatic_Paired"),
#        directory("{origin}/04_SPAdes"),
#        directory("{origin}/05_inputPathogenWatch")
#    message:
#        "Please wait while the results are being copied back to the location of the original rawdata-files"
#    shell:
#        "docker run -it -v {origin_m}:/home/rawdata/ -v {location_m}:/home/Pipeline/ christophevde/ubuntu_bash:1.5 /home/Scripts/04_copy_results.sh"

#--------------------------------------------------------------------------
# Pipeline step1: copying files from original raw data folder to data-folder of current analysis

rule copy_rawdata:
    input: 
        expand(origin+"/{sample_ext}",sample_ext=samples_ext)
    output:
        expand(location+"/data/{id}/00_Rawdata/{id}_L001_R1_001.fastq.gz",id=ids),
        expand(location+"/data/{id}/00_Rawdata/{id}_L001_R2_001.fastq.gz",id=ids)
    message:
        "Please wait while the rawdata is being copied to the current-analysis folder"
    shell:
        "docker run -it -v {origin_m}:/home/rawdata/ -v {location_m}:/home/Pipeline/ christophevde/ubuntu_bash:test /home/Scripts/01_copy_rawdata.sh"
    
#--------------------------------------------------------------------------
# Pipeline step2: running fastqc on the raw-data in the current-analysis folder

rule fastqc_raw:
    input:
        expand(location+"/data/{id}/00_Rawdata/{id}_L001_R1_001.fastq.gz",id=ids),   #the rawdata (output copy_rawdata rule)
        expand(location+"/data/{id}/00_Rawdata/{id}_L001_R2_001.fastq.gz",id=ids)   #the rawdata (output copy_rawdata rule)
    output:
        expand(location+"/data/{id}/01_QC-Rawdata/QC_FastQC/{id}_L001_R1_001_fastqc.html",id=ids),
        expand(location+"/data/{id}/01_QC-Rawdata/QC_FastQC/{id}_L001_R2_001_fastqc.html",id=ids)
    message:
        "Analyzing raw-data with FastQC using Docker-container fastqc:test"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/fastqc:test /home/Scripts/QC01_fastqcRawData.sh"

#--------------------------------------------------------------------------
# Pipeline step3: running multiqc on the raw-data in the current-analysis folder

rule multiqc_raw:
    input:
        expand(location+"/data/{id}/01_QC-Rawdata/QC_FastQC/{id}_L001_R1_001_fastqc.html",id=ids),    #output fastqc rawdata
        expand(location+"/data/{id}/01_QC-Rawdata/QC_FastQC/{id}_L001_R2_001_fastqc.html",id=ids)     #output fastqc rawdata
    output:
        expand(location+"/data/{id}/01_QC-Rawdata/QC_MultiQC/multiqc_report.html",id=ids)             #Results MultiQC for each sample separately
    message:
        "Analyzing raw-data with MultiQC using Docker-container multiqc:test"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/multiqc:test /home/Scripts/QC01_multiqc_raw.sh"

#--------------------------------------------------------------------------
# Pipeline step4: Trimming

rule Trimming:
    input:
        expand(location+"/data/{id}/00_Rawdata/{id}_L001_R1_001.fastq.gz",id=ids),          #the rawdata (output copy_rawdata rule)
        expand(location+"/data/{id}/00_Rawdata/{id}_L001_R2_001.fastq.gz",id=ids),          #the rawdata (output copy_rawdata rule)
        expand(location+"/data/{id}/01_QC-Rawdata/QC_MultiQC/multiqc_report.html",id=ids)   #output multiqc raw (required so that the tasks don't run simultaniously and their outpur gets mixed in the terminal)
    output:
        expand(location+"/data/{id}/02_Trimmomatic/{id}_L001_R1_001_P.fastq.gz",id=ids),
        expand(location+"/data/{id}/02_Trimmomatic/{id}_L001_R2_001_U.fastq.gz",id=ids)
    message:
        "Trimming raw-data with Trimmomatic v0.39 using Docker-container trimmomatic:test"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/trimmomatic:test /home/Scripts/02_runTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step5: FastQC trimmed data (paired reads only)

rule fastqc_trimmed:
    input:
        expand(location+"/data/{id}/02_Trimmomatic/{id}_L001_R1_001_P.fastq.gz",id=ids), #output trimmomatic
        expand(location+"/data/{id}/02_Trimmomatic/{id}_L001_R2_001_U.fastq.gz",id=ids)  #output trimmomatic
    output:
        expand(location+"/data/{id}/03_QC-Trimmomatic_Paired/QC_FastQC/{id}_L001_R1_001_P_fastqc.html",id=ids)
    message:
        "Analyzing trimmed-data with FastQC using Docker-container fastqc:test"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/fastqc:test /home/Scripts/QC02_fastqcTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step6: MultiQC trimmed data (paired reads only) 

rule multiqc_trimmed:
    input:
        expand(location+"/data/{id}/03_QC-Trimmomatic_Paired/QC_FastQC/{id}_L001_R1_001_P_fastqc.html",id=ids)      #output fastqc trimmed data
    output:
        expand(location+"/data/{id}/03_QC-Trimmomatic_Paired/QC_MultiQC/multiqc_report.html",id=ids)
    message:
        "Analyzing trimmed-data with MultiQC using Docker-container multiqc:test"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/multiqc:test /home/Scripts/QC02_multiqcTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step7: SPAdes

rule Spades_InputPathogenwatch:
    input:
        expand(location+"/data/{id}/02_Trimmomatic/{id}_L001_R1_001_P.fastq.gz",id=ids),   # output trimming
        expand(location+"/data/{id}/02_Trimmomatic/{id}_L001_R2_001_U.fastq.gz",id=ids),   # output trimming
        expand(location+"/data/{id}/03_QC-Trimmomatic_Paired/QC_MultiQC/multiqc_report.html",id=ids)    # output multiqc-trimmed
    output:
        expand(location+"/data/{id}/04_SPAdes/dataset.info",id=ids),
        directory(expand(location+"/data/{id}/05_inputPathogenWatch",id=ids))
    message:
        "assembling genome from trimmed-data with SPAdes v3.13.1 using Docker-container SPAdes:test"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/spades:test /home/Scripts/03_spades.sh"

#--------------------------------------------------------------------------

end = time.time()
print(end - start)