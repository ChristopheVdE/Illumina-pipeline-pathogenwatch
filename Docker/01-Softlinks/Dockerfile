# use official ubuntu runtime as parent image
    #server version of ubuntu = 18.04
FROM ubuntu:18.04

# add the 01-softlinks.sh script to the container
    # ADD "location of file on host" file destination in container"
ADD ./01_softlinks.sh ~/01_softlinks.sh

# Run 01-softlinks.sh when the container launches
CMD ["~/01_softlinks.sh"]
