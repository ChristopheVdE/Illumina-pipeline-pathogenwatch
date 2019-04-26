# use official ubuntu runtime as parent image
    #server version of ubuntu = 18.04
FROM ubuntu:18.04

# the raw-data-folder of the host can also be added to the container like this --> but the folder location will be static
    # specify the raw-data-folder in the "$docker run ..." command to make the location dynamic  

# add the 01-softlinks.sh script to the container
    ADD ./01_softlinks.sh ~/01_softlinks.sh
    # Usage: "ADD 'location of file/folder on host' 'file/folder destination in container' "

# Run 01-softlinks.sh when the container launches
CMD ["~/01_softlinks.sh"]
