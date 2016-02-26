#!/bin/bash

# Set Docker to use the machine
eval "$(docker-machine env default)"

docker tag -f didstopia/7dtd-server:latest didstopia/7dtd-server:latest
docker push didstopia/7dtd-server:latest