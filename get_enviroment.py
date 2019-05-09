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
print("location={}".format(location))
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

# write locations and date to file--------------------------------------------------------------------------
loc = open(location+"/enviroment.txt", mode="w")
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