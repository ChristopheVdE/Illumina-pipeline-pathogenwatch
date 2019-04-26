# use official ubuntu runtime as parent image
    #server version of ubuntu = 18.04
FROM ubuntu:18.04

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
    #--> no special packages needed to create softlinks

# Run 01-softlinks.sh when the container launches
CMD ["bin/bash", "sh 01-softlinks.sh"]
