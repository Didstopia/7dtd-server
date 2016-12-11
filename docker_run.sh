#!/bin/bash

./docker_build.sh

# Run the server
#docker run -p 26900:26900 -p 25000:25000/udp -p 25001:25001/udp -p 25002:25002/udp -p 25003:25003/udp -p 8081:8081 -e SEVEN_DAYS_TO_DIE_START_MODE="2" -e SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS="-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated" -v $(pwd)/7dtd_data:/steamcmd/7dtd --name 7dtd-server -d didstopia/7dtd-server:latest
docker run -p 26900:26900 -p 25000:25000/udp -p 25001:25001/udp -p 25002:25002/udp -p 25003:25003/udp -p 8081:8081 -e SEVEN_DAYS_TO_DIE_UPDATE_CHECKING="1" -e SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS="-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated" -v $(pwd)/7dtd_data:/steamcmd/7dtd --name 7dtd-server -d didstopia/7dtd-server:latest
docker logs -f 7dtd-server
