#!/bin/bash

# Set Docker to use the machine
eval "$(docker-machine env default)"

# Create the necessary folder structure
if [ ! -d "7dtd_data" ]; then
  	mkdir -p 7dtd_data
  	cp serverconfig_original.xml 7dtd_data/serverconfig.xml
fi

# Run the server
docker run -p 28015:28015 -p 28015:28015/udp -e SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS="-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated" -v $(pwd)/7dtd_data:/steamcmd/7dtd/server_data --name 7dtd-server -d didstopia/7dtd-server:latest
docker logs -f 7dtd-server