#!/bin/bash

# Set Docker to use the machine
eval "$(docker-machine env default)"

docker commit 7dtd-server didstopia/7dtd-server:latest
