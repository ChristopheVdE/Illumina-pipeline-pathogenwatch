# use official ubuntu runtime as parent image
FROM ubuntu:18.04

# download and install python
RUN  apt-get update \
  && apt-get install -y python \
  && apt-get install -y python-pip \
  && rm -rf /var/lib/apt/lists/*

# download and install MultiQC
RUN pip install multiqc

#check versions of installed packages
RUN python --version
RUN pip --version

# add the FastQC-scripts (pre and post-trimming) to the container
    ADD ./QC01_multiqc_raw.sh /home/Scripts/QC01_multiqc_raw.sh 
    ADD ./QC02_multiqcTrimmomatic.sh /home/Scripts/QC02_multiqcTrimmomatic.sh
    # Usage: "ADD 'location of file/folder on host' 'file/folder destination in container' "


