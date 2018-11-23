#!/bin/bash

./docker_build.sh

# Run the server
docker run -p 26900:26900/tcp -p 26900:26900/udp -p 26901:26901/udp -p 26902:26902/udp -p 8081:8081/tcp -e SEVEN_DAYS_TO_DIE_UPDATE_CHECKING="1" -e SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS="-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated" -v $(pwd)/7dtd_data:/steamcmd/7dtd --name 7dtd-server -it --rm didstopia/7dtd-server:latest
