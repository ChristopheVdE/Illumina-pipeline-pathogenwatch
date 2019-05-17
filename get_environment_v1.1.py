############################################################################################################
#NAME:  get_enviroment.py
#AUTHOR: Christophe Van den Eynde
#FUNCTION: creates some texts files containing location variables that are used by the snakefile as input
#USAGE: pyhton3 get_enviroment.py
############################################################################################################

# GET LOCATIONS=============================================================================================
# input directory (rawdata)----------------------------------------------------------------------------------
import os
print("LOCATION INFO"+"-"*50)
print("Before submitting the rawdata location, please check wheter upper and lower case letters are correct")
print("Windows users using 'Docker-toolbox': \nIt's advised to have the rawdata on the C-drive before the analysis, otherwise there might be problems finding the location")
rawdata = input("\nInput the full path/location of the folder with the raw-data to be analysed:\n")
#TIMER START================================================================================================
import datetime
start = datetime.datetime.now()
#===========================================================================================================

# GET LOCATIONS=============================================================================================
# input directory (origin)----------------------------------------------------------------------------------
import os
origin = input("\nInput the full path/location of the folder with the raw-data to be analysed.\n\
Please check wheter upper and lower case letters are correct:\n\
If using Windows: it's advised to have the rawdata on the C-drive before the analysis, \
otherwise there might be problems finding the location.\n\
DON'T use spaces in your path.\n")
#-----------------------------------------------------------------------------------------------------------

# get current directory-------------------------------------------------------------------------------------
location = os.getcwd()
#===========================================================================================================

# PATH CORRECTION===========================================================================================
#find system-type-------------------------------------------------------------------------------------------
import platform
system=platform.platform()
#-----------------------------------------------------------------------------------------------------------

# fix the path if system is Windows-------------------------------------------------------------------------
import string
if "Windows" in system:
    print("\nWindows based system detected ({}), converting paths for use in Docker:".format(system))
    sys="Windows"
    for i in list(string.ascii_lowercase+string.ascii_uppercase):
        if rawdata.startswith(i+":/"):
            rawdata_m = rawdata.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif rawdata.startswith(i+":\\"):
            rawdata_m = rawdata.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
        if location.startswith(i+":/"):
            location_m = location.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif location.startswith(i+":\\"):
            location_m = location.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
    print(" - Raw-data location ({}) changed to: {}".format(rawdata,rawdata_m))
    print(" - Current location ({}) changed to: {}".format(location,location_m))
# ----------------------------------------------------------------------------------------------------------

# keeping paths as they are if system isn't Windows---------------------------------------------------------
else:
    sys="UNIX"
    rawdata_m = rawdata
    location_m = location
    print("\nUNIX based system detected ({}), paths shouldn't require a conversion for use in Docker:".format(system))
    print(" - rawdata={}".format(rawdata))
    print(" - Current location={}".format(location))
print("-"*63)
print("location={}".format(location))
#-----------------------------------------------------------------------------------------------------------

#check for spaces in the paths------------------------------------------------------------------------------
if ' ' in origin:
    print("\nERROR: spaces found in the path to the rawdata\n")
elif ' ' in location:
    print("\nERROR: spaces found in the path to the current location\n")
else: 
#-----------------------------------------------------------------------------------------------------------

#find system-type-------------------------------------------------------------------------------------------
    import platform
    OS=platform.platform()
#-----------------------------------------------------------------------------------------------------------

# fix the path if system is Windows-------------------------------------------------------------------------
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
        print("\norigin={}".format(origin))
#-----------------------------------------------------------------------------------------------------------

# create location/data--------------------------------------------------------------------------------------
    if not os.path.exists(location+"/data"):
        os.mkdir(location+"/data/")
#-----------------------------------------------------------------------------------------------------------

# write locations to file-----------------------------------------------------------------------------------
    loc = open(location+"/environment.txt", mode="w")
    loc.write("origin="+origin+"\n")
    loc.write("origin_m="+origin_m+"\n")
    loc.write("location="+location+"\n")
    loc.write("location_m="+location_m+"\n")
    loc.close()
#-----------------------------------------------------------------------------------------------------------
#===========================================================================================================

# CREATE SAMPLE LIST========================================================================================
# read directory content------------------------------------------------------------------------------------
ids =[]
for sample in os.listdir(rawdata):
    ids.append(sample.replace('_L001_R1_001.fastq.gz','').replace('_L001_R2_001.fastq.gz',''))
ids = sorted(set(ids))
#-----------------------------------------------------------------------------------------------------------

# writhing samplelist.txt-----------------------------------------------------------------------------------
file = open(location+"/data/sampleList.txt",mode="w")
for i in ids:
    file.write(i+"\n")
file.close()
#===========================================================================================================

# GET MAX THREADS===========================================================================================
# For windows, the threads avaible to docker are already limited by the virtualisation program. 
# This means that the total ammount of threads avaiable on docker is only a portion of the threads avaiable to the host
    # --> no extra limitation needed
# Linux/Mac doesn't use a virutalisation program.
# The number of threads available to docker should be the same as the total number of threads available on the HOST
    # --> extra limitation is needed in order to not slow down the PC to much (reserve CPU for host)
print("\nFetching system info (number of threads) please wait for the next input screen, this shouldn't take long\n")

# MAX THREADS AVAILABLE IN DOCKER----------------------------------------------------------------------------
if sys == "Windows":
    cmd = 'docker run -it --rm \
        --name ubuntu_bash \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v '+location_m+':/home/Pipeline/ \
        christophevde/ubuntu_bash:test \
        /home/Scripts/00_threads.sh'
else:
    cmd = 'docker run -it --rm \
        --name ubuntu_bash \
        --user $(id -u):$(id -g) \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v '+location_m+':/home/Pipeline/ \
        christophevde/ubuntu_bash:test \
        /home/Scripts/00_threads.sh'
os.system(cmd)

env = open("./environment.txt","r")
for line in env.readlines():
    if "threads=" in line:
        d_threads = line.replace("threads=",'').replace('\n','')
env.close()
#-----------------------------------------------------------------------------------------------------------

# TOTAL THREADS OF HOST-------------------------------------------------------------------------------------
import subprocess
if sys == "Windows":
    host = subprocess.Popen('WMIC CPU Get NumberOfLogicalProcessors', shell=True, stdout=subprocess.PIPE)
else:
    host = subprocess.Popen('nproc --all', shell=True, stdout=subprocess.PIPE)
for line in host.stdout:
    # linux only gives a number, Windows gives a text line + a number line
    if any(i in line.decode("UTF-8") for i in ("0","1","2","3","4","5","6","7","8","9")):
        h_threads = int(line.decode("UTF-8"))
        #print(h_threads)
    #print("line="+line.decode("UTF-8"))
#-----------------------------------------------------------------------------------------------------------

# MAX THREADS FOR ANAKYSIS CALCULATION----------------------------------------------------------------------
if sys=="UNIX":
    if h_threads < 5:
        s_threads = h_threads//2
    else:
        s_threads = h_threads//4*3
else:
    s_threads = d_threads
#-----------------------------------------------------------------------------------------------------------

# ASK USER FOR THREADS TO USE-------------------------------------------------------------------------------
# give advanced users the option to overrule the automatic thread detection and specify the ammount themself
# basic users can just press ENTER to accept the automatically sugested ammount of threads

print("ANALYSIS OPTIONS"+"-"*47)
print("Total threads on host: {}".format(h_threads))
print("Max threads in Docker: {}".format(d_threads))
print("Suggest ammount of threads to use in the analysis: {}".format(s_threads))
threads = input("\nInput the ammount of threads to use for the analysis below.\
\nIf you want to use the suggested ammount, just press ENTER (or type in the suggested number)\n")
if threads =='':
    threads = s_threads
    print("\nChosen to use the suggested ammount of threads. Reserved {} threads for Docker".format(threads))
else:
    print("\nManully specified the ammount of threads. Reserved {} threads for Docker".format(threads))
print("-"*63+"\n")
#===========================================================================================================

# WRITE ALL HOST INFO TO FILE===============================================================================
loc = open(location+"/environment.txt", mode="w")
loc.write("rawdata="+rawdata+"\n")
loc.write("rawdata_m="+rawdata_m+"\n")
loc.write("location="+location+"\n")
loc.write("location_m="+location_m+"\n")
loc.write("threads="+str(threads)+"\n")
loc.close()
#===========================================================================================================

# EXECUTE SNAKEMAKE DOCKER==================================================================================
cmd = 'docker run -it --rm \
    --name snakemake \
    --cpuset-cpus="0" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v '+rawdata_m+':/home/rawdata/ \
    -v '+location_m+':/home/Pipeline/ \
    christophevde/snakemake:test \
    /bin/bash -c "cd /home/Snakemake/ && snakemake; /home/Scripts/copy_log.sh"'
os.system(cmd)
#===========================================================================================================
    ids =[]
    for sample in os.listdir(origin):
        ids.append(sample.replace('_L001_R1_001.fastq.gz','').replace('_L001_R2_001.fastq.gz',''))
    ids = sorted(set(ids))
#-----------------------------------------------------------------------------------------------------------

# writhing samplelist.txt-----------------------------------------------------------------------------------
    file = open(location+"/data/sampleList.txt",mode="w")
    for i in ids:
        file.write(i+"\n")
    file.close()
#-----------------------------------------------------------------------------------------------------------
#===========================================================================================================

# EXECUTE SNAKEMAKE DOCKER----------------------------------------------------------------------------------
    cmd = 'docker run -it --rm  -v /var/run/docker.sock:/var/run/docker.sock \
        -v '+origin_m+':/home/rawdata/ \
        -v '+location_m+':/home/Pipeline/ \
        --name snakemake \
        christophevde/snakemake:stable \
        /bin/bash -c "cd /home/Snakemake/ && snakemake ; /home/Scripts/copy_log.sh"'
    #print(cmd)
    os.system(cmd)
#-----------------------------------------------------------------------------------------------------------

#TIMER END==================================================================================================
end = datetime.datetime.now()
timer = end - start
#conver to human readable

print("Analysis took: {} (H:MM:SS) \n".format(timer))
#===========================================================================================================
