# ask for input directory (origin)
import os
origin = input("Input the full path/location of the folder with the raw-data to be analysed. \
Please check wheter upper and lower case letters are correct:\n")

print("\norigin={}".format(origin))

# get current directory
location = os.getcwd()
print("location={}".format(location))

# creating sample-list (has file extensions)
samples_ext = os.listdir(origin)

#removing file extensions for samples_ext
samples = []
for sample_ext in samples_ext:
    samples.append(sample_ext.replace('.fastq.gz', ''))

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
        location+("/data/01_QC-Rawdata/QC_MultiQC/multiqc_report.html"),                            
        location+("/data/03_QC-Trimmomatic_Paired/QC_MultiQC/multiqc_report.html"),                       
        location+("/data/04_SPAdes/spades.log"),                                                    
        location+("/data/04_SPAdes/params.txt")                                                      
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
#        "docker run -it -v {origin_m}:/home/rawdata/ -v {location_m}:/home/Pipeline/ christophevde/ubuntu_bash:1.4 /home/Scripts/04_rename+copy.sh"

#--------------------------------------------------------------------------
# Pipeline step1: copying files from original raw data folder to data-folder of current analysis

rule copy_rawdata:
    input: 
        expand(origin+"/{sample_ext}",sample_ext=samples_ext)
    output:
        expand(location+"/data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)
    message:
        "Please wait while the rawdata is being copied to the current-analysis folder"
    shell:
        "docker run -it -v {origin_m}:/home/rawdata/ -v {location_m}:/home/Pipeline/ christophevde/ubuntu_bash:1.4 /home/Scripts/01_copy_rawdata.sh"
    
#--------------------------------------------------------------------------
# Pipeline step2: running fastqc on the raw-data in the current-analysis folder

rule fastqc_raw:
    input:
        expand(location+"/data/00_Rawdata/{sample_ext}",sample_ext=samples_ext)     #the rawdata (output copy_rawdata rule)
    output:
        expand(location+"/data/01_QC-Rawdata/QC_fastqc/{sample}_fastqc.html",sample=samples)
    message:
        "Analyzing raw-data with FastQC using Docker-container fastqc:2.1"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/fastqc:2.1 /home/Scripts/QC01_fastqcRawData.sh"

#--------------------------------------------------------------------------
# Pipeline step3: running multiqc on the raw-data in the current-analysis folder

rule multiqc_raw:
    input:
        expand(location+"/data/01_QC-Rawdata/QC_fastqc/{sample}_fastqc.html",sample=samples)    #output fastqc rawdata
    output:
        "{location}/data/01_QC-Rawdata/QC_MultiQC/multiqc_report.html"
    message:
        "Analyzing raw-data with MultiQC using Docker-container multiqc:2.1"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/multiqc:2.1 /home/Scripts/QC01_multiqc_raw.sh"

#--------------------------------------------------------------------------
# Pipeline step5: Trimming

rule Trimming:
    input:
        expand(location+"/data/00_Rawdata/{sample_ext}",sample_ext=samples_ext),    #the rawdata (output copy_rawdata rule)
        location+"/data/01_QC-Rawdata/QC_MultiQC/multiqc_report.html"               #output multiqc raw (required so that the tasks don't run simultaniously and their outpur gets mixed in the terminal)
    output:
        expand(location+"/data/02_Trimmomatic/{sample}_P.fastq.gz",sample=samples),
        expand(location+"/data/02_Trimmomatic/{sample}_U.fastq.gz",sample=samples)
    message:
        "Trimming raw-data with Trimmomatic v0.39 using Docker-container trimmomatic:1.1"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/trimmomatic:1.1 /home/Scripts/02_runTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step5: FastQC trimmed data (paired reads only)

rule fastqc_trimmed:
    input:
        expand(location+"/data/02_Trimmomatic/{sample}_P.fastq.gz",sample=samples),           #output trimmomatic
        expand(location+"/data/02_Trimmomatic/{sample}_U.fastq.gz",sample=samples)            #output trimmomatic
    output:
        expand(location+"/data/03_QC-Trimmomatic_Paired/QC_fastqc/{sample}_P_fastqc.html",sample=samples)
    message:
        "Analyzing trimmed-data with FastQC using Docker-container fastqc:2.1"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/fastqc:2.1 /home/Scripts/QC02_fastqcTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step6: MultiQC trimmed data (paired reads only) 

rule multiqc_trimmed:
    input:
        expand(location+"/data/03_QC-Trimmomatic_Paired/QC_fastqc/{sample}_P_fastqc.html",sample=samples)      #output fastqc trimmed data
    output:
        "{location}/data/03_QC-Trimmomatic_Paired/QC_MultiQC/multiqc_report.html"
    message:
        "Analyzing trimmed-data with MultiQC using Docker-container multiqc:2.1"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/multiqc:2.1 /home/Scripts/QC02_multiqcTrimmomatic.sh"

#--------------------------------------------------------------------------
# Pipeline step7: SPAdes

rule Spades:
    input:
        expand(location+"/data/02_Trimmomatic/{sample}_P.fastq.gz",sample=samples),    # output trimming
        expand(location+"/data/02_Trimmomatic/{sample}_U.fastq.gz",sample=samples),    # output trimming
        location+("/data/03_QC-Trimmomatic_Paired/QC_MultiQC/multiqc_report.html")    # output multiqc-trimmed
    output:
        "{location}/data/04_SPAdes/spades.log",
        "{location}/data/04_SPAdes/params.txt"
    message:
        "assembling genome from trimmed-data with SPAdes v3.13.1 using Docker-container SPAdes:1.0"
    shell:
        "docker run -it -v {location_m}/data:/home/data/ christophevde/SPAdes:1.0 /home/Scripts/03_spades.sh"

#--------------------------------------------------------------------------

# /media/sf_Courses/BIT11-Stage/Data/Fastq
