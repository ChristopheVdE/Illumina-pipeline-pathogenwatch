############################################################################################################
#NAME:  get_enviroment.py
#AUTHOR: Christophe Van den Eynde
#FUNCTION: creates some texts files containing location variables that are used by the snakefile as input
#USAGE: pyhton3 get_enviroment.py
############################################################################################################

#TIMER START================================================================================================
import datetime
start = datetime.datetime.now()
#===========================================================================================================

#IMPORT PACKAGES============================================================================================
import platform
import subprocess
import os
import string
#===========================================================================================================

#FUNCTIONS: TIPS============================================================================================
#TIPS TO GIVE DOCKER ACCES TO FOLDERS/ DRIVES---------------------------------------------------------------
def drive_acces(sys, HyperV):
    if sys=="Windows":
        if HyperV=="False":
            print("Docker-toolbox for Windows detected:")
            print("To give Docker acces to more drives:")
            print("   1) Open Oracle Virtual Box")
            print("   2) Select the Docker Virtual machine, click on settings (the cogwheel) and then on 'Shared folders'")
            print("   3) Click on 'add shared folder', provide the path to the folder, name the folder and select 'automatic mounting'")
            print("[WARNING] The paths of the newly added shared-folders might not work in this script (Untested)")
            print("It's advised to have both the RAWDATA and the RESULTS folder on the C-drive before the analysis, otherwise there might be problems finding the location\n")
        else:
            print("Docker Desktop for Windows detected:")
            print("To give Docker acces to more drives:")
            print("   1) Right click on the Docker desktop icon in the taskbar and select 'Settings'")
            print("   2) Go to 'Shared Drives'")
            print("   3) Check to boxes for the drives you want docker to have acces to and press 'Apply'. Windows will ask for your password afther wich Docker will restart and the folders should be available")
            print("[WARNING] Changing your Windows password can apparently break Docker's acces to the shared drives, just repeat the above steps and provide your new password to fix this")
#TIPS TO MANAGE DOCKER RECOURCES----------------------------------------------------------------------------
def docker_recources(sys, HyperV):
    if sys=="Windows":
        print("\nTIP to increase performance (make more threads available to docker)")
        if HyperV=="True":
            print("  1) Open the settings menu of 'Docker Desktop'")
            print("  2) Go to the advanced tab")
            print("  3) Increase the CPU and RAM (memory) available to Docker by moving the corresponding sliders.")
            print("     It's advised to keep some CPU and RAM reserved for the host system") 
        else:
            print("  1) Open Oracle Virtual Box")
            print("  2) Select the Docker virtual image")
            print("  3) Click on the cogwheel (settings)")
            print("  4) Open the system menu")
            print("  5) Increase basic memory by moving the slider (keep the slider in the green part)")
            print("  6) Go to the processor tab in the system menu ")
            print("  7) Increase available CPu by moving the slider (keep the slider in the green part)")
#===========================================================================================================

#FETCH OS-TYPE==============================================================================================
print("Please wait while the Script fetches some system info.")
system=platform.system()
if "Windows" in system:
    sys = "Windows"
    print("\nWindows based system detected ({})\n".format(system))
    # check if HyperV is enabled (indication of docker Version, used to give specific tips on preformance increase)
    HV = subprocess.Popen('powershell.exe get-service | findstr vmcompute', shell=True, stdout=subprocess.PIPE) 
    for line in HV.stdout:  
        if "Running" in line.decode("utf-8"):
            HyperV="True" 
        else: 
            HyperV="False"
elif "Darwin" in system:
    sys = "MacOS"
    print("\nMacOS based system detected ({})\n".format(system))
else:
    sys = "UNIX"
    print("\nUNIX based system detected ({})\n".format(system))
#===========================================================================================================

# GET MAX THREADS===========================================================================================
    # For windows, the threads avaible to docker are already limited by the virtualisation program. 
    # This means that the total ammount of threads avaiable on docker is only a portion of the threads avaiable to the host
    # --> no extra limitation needed
    # Linux/Mac doesn't use a virutalisation program.
    # The number of threads available to docker should be the same as the total number of threads available on the HOST
    # --> extra limitation is needed in order to not slow down the PC to much (reserve CPU for host)
# TOTAL THREADS OF HOST-------------------------------------------------------------------------------------
if sys == "Windows":
    host = subprocess.Popen('WMIC CPU Get NumberOfLogicalProcessors', shell=True, stdout=subprocess.PIPE)
elif sys == "MacOS":
    host = subprocess.Popen('sysctl -n hw.ncpu', shell=True, stdout=subprocess.PIPE)
else:
    host = subprocess.Popen('nproc --all', shell=True, stdout=subprocess.PIPE)

for line in host.stdout:
    # linux only gives a number, Windows gives a text line + a number line
    if any(i in line.decode("UTF-8") for i in ("0","1","2","3","4","5","6","7","8","9")):
        h_threads = int(line.decode("UTF-8"))
# MAX THREADS AVAILABLE IN DOCKER----------------------------------------------------------------------------
docker = subprocess.Popen('docker run -it --rm --name ubuntu_bash christophevde/ubuntu_bash:v2.0_stable nproc --all', shell=True, stdout=subprocess.PIPE)
for line in docker.stdout:
    d_threads = int(line.decode("UTF-8"))
# SUGESTED THREADS FOR ANALYSIS CALCULATION-----------------------------------------------------------------
if sys=="UNIX":
    if h_threads < 5:
        s_threads = h_threads//2
    else:
        s_threads = h_threads//4*3
else:
    s_threads = d_threads
print("Done")
#===========================================================================================================

#GET INPUT==================================================================================================
options = {}
#TEST FOR COMMAND LINE ARGUMENTS----------------------------------------------------------------------------
try:
    options["Illumina"] = sys.argv[1]
    options["Results"] = sys.argv[2]
    try:
        options["Threads"] = sys.argv[3]
    except:
        print("Threads not specified, using suggested amount")
    try:
        options["Adapters"] = sys.argv[4]
    except:
        print("Adaptors not specified, using build in adaptor file for trimming")
#LOCATIONS--------------------------------------------------------------------------------------------------
except:
    if sys == "Windows":
        tips = input("\nDo you want to display tips when appropriate? (y/n): ").lower()
    else:
        tips = 'n'
    print("\nLOCATION INFO"+"-"*50)
    if tips == 'y':
        drive_acces(sys, HyperV)
    print("\nBefore submitting the locations, please check wheter upper and lower case letters are correct")
    options["Illumina"] = input("\nInput the full path/location of the folder with the raw-data to be analysed:\n")
    options["Results"] = input("\nInput the full path/location of the folder where you want to save the analysis result:\n")
    options["Adapters"] = input("\nInput the full path/location of the multifasta containing the adapter-sequences to trim. \
        \n Press ENTER to use the build in adapter file for trimming.")
    options["Scripts"] = os.path.dirname(os.path.realpath(__file__)) + "/Docker"
#CHECK FOR ADAPTER INPUT, USE DEFAULT IF NOT PROVIDED--------------------------------------------------------
    if options["Adapters"] == '':
        options["Adapters"] = options["Scripts"]+'/04-Trimmomatic/NexteraPE-PE.fa'
#THREADS-----------------------------------------------------------------------------------------------------
# give advanced users the option to overrule the automatic thread detection and specify the ammount themself
# basic users can just press ENTER to accept the automatically sugested ammount of threads
    print("\nANALYSIS OPTIONS"+"-"*47)
    if tips =='y':
        docker_recources(sys, HyperV)
    print("\nTotal threads on host: {}".format(h_threads))
    print("Max threads in Docker: {}".format(d_threads))
    print("Suggest ammount of threads to use in the analysis: {}".format(s_threads))
    options["Threads"] = input("\nInput the ammount of threads to use for the analysis below.\
    \nIf you want to use the suggested ammount, just press ENTER (or type in the suggested number)\n")
    if options["Threads"] =='':
        options["Threads"] = str(s_threads)
        print("\nChosen to use the suggested ammount of threads. Reserved {} threads for Docker".format(options["Threads"]))
    else:
        print("\nManually specified the ammount of threads. Reserved {} threads for Docker".format(options["Threads"]))
    print("-"*63+"\n")
#===========================================================================================================

#CREATE LOCATION/ DATA======================================================================================
folders = [options["Results"],]
for i in folders:
    if not os.path.exists(i):
        os.mkdir(i)
#===========================================================================================================

#CONVERT MOUNT_PATHS (INPUT) IF REQUIRED====================================================================  
options_copy = options
options = {}
not_convert = ["Threads",]
if system=="Windows":
    print("\nConverting Windows paths for use in Docker:")
    for key, value in options_copy.items():
        options[key] = value
        for i in list(string.ascii_lowercase+string.ascii_uppercase):
            if value.startswith(i+":/"):
                options[key+"_m"] = value.replace(i+":/","/"+i.lower()+"//").replace('\\','/')
            elif value.startswith(i+":\\"):
                options[key+"_m"] = value.replace(i+":\\","/"+i.lower()+"//").replace('\\','/')
        if not key in not_convert:  
            print(" - "+ key +" location ({}) changed to: {}".format(str(options[key]),str(options[key+"_m"])))
else:
    print("\nUNIX paths shouldn't require a conversion for use in Docker:")
    for key, value in options_copy.items():
        if not key in not_convert:
            options[key+"_m"] = value
            print(" - "+ key +" location ({}) changed to: {}".format(str(options[key]),str(options[key+"_m"])))
#===========================================================================================================

# CREATE SAMPLE LIST========================================================================================
# READ DIRECTORY CONTENT------------------------------------------------------------------------------------
ids =[]
for sample in os.listdir(options["Illumina"]):
    if ".fastq.gz" in sample:
        ids.append(sample.replace('_L001_R1_001.fastq.gz','').replace('_L001_R2_001.fastq.gz',''))
ids = sorted(set(ids))
# WRITING SAMPLELIST TO FILE--------------------------------------------------------------------------------
file = open(options["Results"]+"/sampleList.txt",mode="w")
for i in ids:
    file.write(i+"\n")
file.close()
#===========================================================================================================

# WRITE INPUT FILE==========================================================================================
loc = open(options["Results"]+"/environment.txt", mode="w")
for key, value in options.items():
    if not key == "Threads":
        loc.write(key+"="+value+"\n")
    else:
        loc.write(key+"="+value)  
loc.close()
#===========================================================================================================

#EXECUTE PIPELINE===========================================================================================
#COPY/ MOVE RAWDATA TO RESULTS/00_RAWDATA-------------------------------------------------------------------
# Copy/ move files from raw data folder to 'Sample_id/00_Rawdata/' in the analysis-results folder
print("Please wait while the rawdata is being copied to the current-analysis folder")
if options["Illumina"] == options["Results"]:
    # mount only the rawdata folder if rawdata and results folders are the same
    move = 'docker run -it --rm \
        --name copy_rawdata \
        -v "'+options["Illumina_m"]+':/home/rawdata/" \
        -v "'+options["Scripts_m"]+'/01-Bash:/home/Scripts/" \
        christophevde/ubuntu_bash:v2.2_stable \
        /bin/bash -c "dos2unix /home/Scripts/01_move_rawdata.sh \
        && /home/Scripts/01_move_rawdata.sh"'
    os.system(move)
else:
    # mount both the rawdata and the results folder
    copy = 'docker run -it --rm \
        --name copy_rawdata \
        -v "'+options["Illumina_m"]+':/home/rawdata/" \
        -v "'+options["Results_m"]+':/home/Pipeline/" \
        -v "'+options["Scripts_m"]+'/01-Bash:/home/Scripts/" \
        christophevde/ubuntu_bash:v2.2_stable \
        /bin/bash -c "dos2unix /home/Scripts/01_copy_rawdata.sh \
        && /home/Scripts/01_copy_rawdata.sh"'
    os.system(copy)
print("Done\n")
#EXECUTE SNAKEMAKE DOCKER CONTAINER-------------------------------------------------------------------------
# Make shure that the end of lines are correct for Linux before mounting the Snakemake-Scripts folder as read only
dos2unix = 'docker run -it --rm \
    --name dos2unix \
    --cpuset-cpus="0" \
    -v "'+options["Scripts_m"]+'/00-Snakemake:/home/Scripts/" \
    christophevde/ubuntu_bash:v2.2_stable \
    /bin/bash -c "dos2unix /home/Scripts/copy_log.sh && /home/Scripts/copy_log.sh"'
os.system(dos2unix)
# Execute snakemake
snake = 'docker run -it --rm \
    --name snakemake \
    --cpuset-cpus="0" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "'+options["Results_m"]+':/home/Pipeline/" \
    -v "'+options["Scripts_m"]+'/00-Snakemake:/home/Scripts/" \
    christophevde/snakemake:v2.3_stable \
    /bin/bash -c "cd /home/Scripts/ && snakemake; /home/Scripts/copy_log.sh"'
os.system(snake)
#REMOVE DUPLICATE RAWDATA FILES-----------------------------------------------------------------------------
# Delete the fastq.files in the original rawdata/ folder (they have been copied to 00_Rawdata/).
# This is the final step because otherwise snakemake would complain over missing files if it was terminated 
# mid analysis and needs to continue on a different time
delete = 'docker run -it --rm \
    --name copy_rawdata \
    -v "'+options["Illumina_m"]+':/home/rawdata/" \
    -v "'+options["Scripts_m"]+'/01-Bash:/home/Scripts/" \
    christophevde/ubuntu_bash:v2.2_stable \
    /bin/bash -c "dos2unix /home/Scripts/02_delete_rawdata.sh \
    && /home/Scripts/02_delete_rawdata.sh"'
os.system(delete)
#===========================================================================================================

#TIMER END==================================================================================================
end = datetime.datetime.now()
timer = end - start
#conver to human readable
print("Analysis took: {} (H:MM:SS) \n".format(timer))
#===========================================================================================================
