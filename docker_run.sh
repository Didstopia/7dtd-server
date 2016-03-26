#!/bin/bash

# Set Docker to use the machine
eval "$(docker-machine env default)"

# Run the server
docker run -e SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS="-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated" -v $(pwd)/7dtd_data:/steamcmd/7dtd --name 7dtd-server -d didstopia/7dtd-server:latest
docker logs -f 7dtd-server