############################################################################################################
#NAME:  get_enviroment.py
#AUTHOR: Christophe Van den Eynde
#FUNCTION: creates some texts files containing location variables that are used by the snakefile as input
#USAGE: pyhton3 get_enviroment.py
############################################################################################################

# GET LOCATIONS=============================================================================================
# input directory (origin)----------------------------------------------------------------------------------
import os
origin = input("\nInput the full path/location of the folder with the raw-data to be analysed.\n\
Please check wheter upper and lower case letters are correct:\n\
If using Windows: it's advised to have the rawdata on the C-drive before the analysis, \
otherwise there might be problems finding the location\n")
#-----------------------------------------------------------------------------------------------------------

# get current directory-------------------------------------------------------------------------------------
location = os.getcwd()
print("Current location={}".format(location))
#-----------------------------------------------------------------------------------------------------------

#find system-type-------------------------------------------------------------------------------------------
import platform
system=platform.platform()
#-----------------------------------------------------------------------------------------------------------

# fix the path if system is Windows-------------------------------------------------------------------------
import string
if "Windows" in system:
    print("\nWindows based system detected ({}), fixing paths".format(system))
    sys="Windows"
    for i in list(string.ascii_lowercase+string.ascii_uppercase):
        if origin.startswith(i+":/"):
            origin_m = origin.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif origin.startswith(i+":\\"):
            origin_m = origin.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
        if location.startswith(i+":/"):
            location_m = location.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
        elif location.startswith(i+":\\"):
            location_m = location.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
    print("\tRaw-data location ({}) changed to: {}".format(origin,origin_m))
    print("\tCurrent location ({}) changed to: {}\n".format(location,location_m))
# ----------------------------------------------------------------------------------------------------------

# keeping paths as they are if system isn't Windows---------------------------------------------------------
else:
    origin_m = origin
    location_m = location
    sys="UNIX"
    print("\nUNIX based system detected ({}), paths shouldn't require fixing".format(system))
    print("\norigin={}".format(origin))
#-----------------------------------------------------------------------------------------------------------

#===========================================================================================================

# CREATE SAMPLE LIST========================================================================================
# read directory content------------------------------------------------------------------------------------
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

# GET MAX THREADS===========================================================================================
# MAX THREADS AVAIABLE IN DOCKER---------------------------------------------------------------------------

# for windows, this is everything it can take since the threads avaible to docker are already 
# limited by the virtualisation program
# for Linux/Mac, the number of threads available to docker would be the same as those available on the HOST
# so an extra limitation is needed in order to not slow down the PC to much

cmd = 'docker run -it --rm \
    --name ubuntu_bash \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v '+location_m+':/home/Pipeline/ \
    christophevde/ubuntu_bash:test \
    /home/Scripts/00_threads.sh'
os.system(cmd)
#-----------------------------------------------------------------------------------------------------------

# SPECIFY MAX THREADS FOR LINUX/ MAC------------------------------------------------------------------------
env = open("/home/Pipeline/environment.txt","r")
for line in env.readlines():
    if "threads=" in line:
        threads = line.replace("threads=",'').replace('\n','')
env.close()

if sys=="UNIX":
    if threads < 5:
        threads = threads/2
    else:
        threads = threads//4*3
    print("{} threads reserved for Docker".format(threads))
else:
    print("{} threads reserved for Docker".format(threads))
#-----------------------------------------------------------------------------------------------------------
#===========================================================================================================

# WRITE ALL HOST INFO TO FILE===============================================================================
loc = open(location+"/environment.txt", mode="w")
loc.write("origin="+origin+"\n")
loc.write("origin_m="+origin_m+"\n")
loc.write("location="+location+"\n")
loc.write("location_m="+location_m+"\n")
loc.write("threads="+threads+"\n")
loc.close()
#===========================================================================================================

# EXECUTE SNAKEMAKE DOCKER==================================================================================
cmd = 'docker run -it --rm \
    --name snakemake \
    --cpus=1 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v '+origin_m+':/home/rawdata/ \
    -v '+location_m+':/home/Pipeline/ \
    christophevde/snakemake:stable \
    /bin/bash -c "cd /home/Snakemake/ && snakemake ; /home/Scripts/copy_log.sh"'
os.system(cmd)
#===========================================================================================================