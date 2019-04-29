# use official ubuntu runtime as parent image
FROM ubuntu:18.04

# download and install wget
RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y zip \
  && rm -rf /var/lib/apt/lists/*

# download and install openJDK 10.0.2+13 (server version of openjdk (java) = 10.0.2+13)
RUN wget "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
RUN tar xvf openjdk-10*_bin.tar.gz

# download and install fastqc
ENV URL=https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
ENV ZIP=fastqc_v0.11.8.zip
ENV DST=/home

RUN wget $URL/$ZIP -O $DST/$ZIP
RUN unzip - $DST/$ZIP -d $DST
RUN rm $DST/$ZIP
RUN chmod 755 $DST/FastQC/fastqc
RUN ln -s $DST/FastQC/fastqc /usr/local/bin/fastqc

ENV PATH /usr/local/bin:$PATH

# the raw-data-folder of the host can also be added to the container like this --> but the folder location will be static
    # specify the raw-data-folder in the "$docker run ..." command to make the location dynamic
    
# add the FastQC-scripts (pre and post-trimming) to the container
    ADD ./QC01_fastqcRawData.sh ~/Scripts/QC01_fastqcRawData.sh 
    ADD ./QC02_fastqcTrimmomatic.sh ~/Scripts/QC02_fastqcTrimmomatic.sh
    # Usage: "ADD 'location of file/folder on host' 'file/folder destination in container' "

