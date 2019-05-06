# use official ubuntu runtime as parent image
FROM ubuntu:18.04

# download and install python
RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y python \
  && rm -rf /var/lib/apt/lists/*

# download and install SPAdes
RUN wget http://cab.spbu.ru/files/release3.13.1/SPAdes-3.13.1-Linux.tar.gz
RUN tar -xzf SPAdes-3.13.1-Linux.tar.gz
RUN cd SPAdes-3.13.1-Linux/bin/

#check versions of installed packages
RUN python --version

# add the Spades-script to the container
    ADD ./03_spades.sh ~/Scripts/03_spades.sh
    # Usage: "ADD 'location of file/folder on host' 'file/folder destination in container' "


