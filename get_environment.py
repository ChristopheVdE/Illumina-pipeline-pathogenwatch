############################################################################################################
#NAME:  get_enviroment.py
#AUTHOR: Christophe Van den Eynde
#FUNCTION: creates some texts files containing location variables that are used by the snakefile as input
#USAGE: pyhton3 get_enviroment.py
############################################################################################################

#TIMER START================================================================================================
import time
start = time.process_time()
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
    os.system(cmd)
#-----------------------------------------------------------------------------------------------------------

#TIMER END==================================================================================================
end = time.process_time()
timer = end - start
#conver to human readable
days = timer // 86400
hours = timer // 3600 % 24
minutes = timer // 60 % 60
seconds = timer % 60
print("Analysis took: {} days, {} hours, {} minutes and {} seconds\n".format(days,hours,minutes,seconds))
#===========================================================================================================
