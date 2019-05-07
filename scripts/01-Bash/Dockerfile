# use official ubuntu runtime as parent image
    #server version of ubuntu = 18.04
FROM ubuntu:18.04

RUN  apt-get update \
  && apt-get install -y dos2unix \
  && rm -rf /var/lib/apt/lists/*

# the raw-data-folder of the host can also be added to the container like this --> but the folder location will be static
    # specify the raw-data-folder in the "$docker run ..." command to make the location dynamic
    
# add the scripts to the container
    # Usage: "ADD 'location of file/folder on host' 'file/folder destination in container' "
    ADD ./01_copy_rawdata.sh /home/Scripts/01_copy_rawdata.sh
    ADD ./04_rename+copy.sh /home/Scripts/04_copy_results.sh
    ADD ./02_samplelist.sh /home/Scripts/02_samplelist.sh
# fix execute rights if necessairy
    RUN chmod 755 /home/Scripts/01_copy_rawdata.sh
    RUN chmod 755 /home/Scripts/04_copy_results.sh
    RUN chmod 755 /home/Scripts/02_samplelist.sh
# convert Windows EOL to UNIX EOL (required when scripts where manipulated in Windows)
    RUN dos2unix /home/Scripts/01_copy_rawdata.sh
    RUN dos2unix /home/Scripts/04_copy_results.sh
    RUN dos2unix /home/Scripts/02_samplelist.sh
