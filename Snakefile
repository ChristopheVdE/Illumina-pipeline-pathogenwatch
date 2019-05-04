# ask for input directory (origin)
import os
origin = input("Input the full path/location of the folder with the raw-data to be analysed. \
Please check wheter upper and lower case letters are correct:\n")

print("\norigin={}".format(origin))

# get current directory
location = os.getcwd()
print("location={}".format(location))

#find system-type
import platform
OS=platform.platform()

# fix the path if system is Windows
import string
if "Windows" in OS:
    print("\nWindows based system detected ({}), fixing paths".format(OS))
    for i in list(string.ascii_lowercase+string.ascii_uppercase):
        if origin.startswith(i+":/"):
            origin = origin.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif origin.startswith(i+":\\"):
            origin = origin.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
        if location.startswith(i+":/"):
            location = location.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif location.startswith(i+":\\"):
            location = location.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
    print("\torigin changed to: {}".format(origin))
    print("\tlocation changed to: {}\n".format(location))
else:
    print("\nUNIX based system detected ({}), paths shouldn't require fixing".format(OS))

# creating sample-list (has file extensions)
samples_ext = os.listdir(origin)

#removing file extensions for samples_ext
samples = []
for sample_ext in samples_ext:
        samples.append(sample_ext.replace('.fastq.gz', ''))

#--------------------------------------------------------------------------

rule all:
    input:
        location+("/data/01_QC-Rawdata/QC_MultiQC/multiqc_report.html"),
        location+("/data/03_QC-Trimmomatic/QC_MultiQC/multiqc_report.html")
        #"directory(data/04_SPAdes/*)"

#--------------------------------------------------------------------------
# Pipeline step1: copying files from original raw data folder to data-folder of current analysis

rule copy_files:
    input: 
        expand(origin+"/{sample_ext}",sample_ext=samples_ext)
    output:
        expand(location+"/data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)
    message:
        "Please wait while the files are being copied"
    shell:
        "docker run -it -v {origin}:/home/rawdata/ -v {location}:/home/Pipeline/ christophevde/ubuntu_bash:1.0 /home/Scripts/01_copy_rawdata.sh"
    
#--------------------------------------------------------------------------
# Pipeline step2: running fastqc on the raw-data in the current-analysis folder

rule fastqc_raw:
    input:
        expand(location+"/data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)
    output:
        expand(location+"/data/01_QC-Rawdata/QC_fastqc/{sample}_fastqc.html",sample=samples)
    message:
        "Analyzing raw-data with FastQC using Docker-container fastqc:2.0"
    shell:
        "docker run -it -v {location}/data:/home/data/ christophevde/fastqc:2.0 /home/Scripts/QC01_fastqcRawData.sh"

#--------------------------------------------------------------------------
# Pipeline step3: running multiqc on the raw-data in the current-analysis folder

rule multiqc_raw:
    input:
        expand(location+"/data/01_QC-Rawdata/QC_fastqc/{sample}_fastqc.html",sample=samples)
    output:
        "{location}/data/01_QC-Rawdata/QC_MultiQC/multiqc_report.html"
    message:
        "Analyzing raw-data with MultiQC using Docker-container multiqc:2.0"
    shell:
        "docker run -it -v {location}/data:/home/data/ christophevde/multiqc:2.0 /home/Scripts/QC01_multiqc_raw.sh"

#--------------------------------------------------------------------------
# Pipeline step5: Trimming

rule Trimming:
    input:
        expand(location+"/data/00_Rawdata/{sample_ext}",sample_ext=samples_ext),
        location+"/data/01_QC-Rawdata/QC_MultiQC/multiqc_report.html"
    output:
        expand(location+"/data/02_Trimmomatic/{sample}_P.fastq.gz",sample=samples),
        expand(location+"/data/02_Trimmomatic/QC_fastqc/{sample}_U.fastq.gz",sample=samples)
    message:
        "Trimming raw-data with Trimmomatic v0.39 using Docker-container trimmomatic:1.1"
    shell:
        "docker run -it -v {location}/data:/home/data/ christophevde/trimmomatic:1.1 /home/Scripts/02_runTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step5: FastQC trimmed data

rule fastqc_trimmed:
    input:
        expand(location+"/data/02_Trimmomatic/{sample}_P.fastq.gz",sample=samples),
        expand(location+"/data/02_Trimmomatic/QC_fastqc/{sample}_U.fastq.gz",sample=samples)
    output:
        expand(location+"/data/03_QC-Trimmomatic/QC_fastqc/{sample}_U_fastqc.html",sample=samples),
        expand(location+"/data/03_QC-Trimmomatic/QC_fastqc/{sample}_P_fastqc.html",sample=samples)
    message:
        "Analyzing trimmed-data with FastQC using Docker-container fastqc:2.0"
    shell:
        "docker run -it -v {location}/data:/home/data/ christophevde/fastqc:2.0 /home/Scripts/QC02_fastqcTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step6: MultiQC trimmed data

rule multiqc_trimmed:
    input:
        expand(location+"/data/03_QC-Trimmomatic/QC_fastqc/{sample}_U_fastqc.html",sample=samples),
        expand(location+"/data/03_QC-Trimmomatic/QC_fastqc/{sample}_P_fastqc.html",sample=samples)
    output:
        "{location}/data/03_QC-Trimmomatic/QC_MultiQC/multiqc_report.html"
    message:
        "Analyzing trimmed-data with MultiQC using Docker-container multiqc:2.00"
    shell:
        "docker run -it -v {location}/data:/home/data/ christophevde/multiqc:2.0 /home/Scripts/QC02_multiqcTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step7: Spades

# /media/sf_Courses/BIT11-Stage/Data/Fastq
