FROM ubuntu:14.04

# Add support for 32-bit architecture
RUN dpkg --add-architecture i386

# Run a quick apt-get update/upgrade
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y

# Install dependencies, mainly for SteamCMD
RUN apt-get install --no-install-recommends -y \
    ca-certificates \
    software-properties-common \
    python-software-properties \
    screen \
    libc6-amd64 \
    Xvfb \
    lib32gcc1 \
    net-tools \
    lib32stdc++6 \
    lib32z1 \
    lib32z1-dev \
    curl \
    wget \
    telnet

# Run as root
USER root

# Install SteamCMD
RUN mkdir -p /steamcmd/7dtd && \
	curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /steamcmd -zx

# Create the server directory
RUN mkdir -p /steamcmd/7dtd/server_data

# Set the current working directory and the current user
WORKDIR /steamcmd

# Install/update from install.txt
ADD install.txt /steamcmd/install.txt
RUN /steamcmd/steamcmd.sh +runscript /steamcmd/install.txt

# Copy startup script
ADD start_7dtd.sh /steamcmd/7dtd/start.sh

# Copy the default server config in place
ADD serverconfig_original.xml /steamcmd/7dtd/server_data/serverconfig.xml

# Create an empty log file
RUN touch /steamcmd/7dtd/server_data/7dtd.log

# Set the server_data up as a volume
VOLUME ["/steamcmd/7dtd/server_data"]

# Expose necessary ports
EXPOSE 26900
EXPOSE 25000
EXPOSE 25001
EXPOSE 25002
EXPOSE 25003
EXPOSE 8080
EXPOSE 8081

# Setup default environment variables for the server
ENV SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS "-configfile=server_data/serverconfig.xml -logfile /dev/stdout -quit -batchmode -nographics -dedicated"

# Start the server
WORKDIR /steamcmd/7dtd
CMD bash start.sh
