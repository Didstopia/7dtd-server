FROM ubuntu:16.04

# Run a quick apt-get update/upgrade
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y

# Install dependencies, mainly for SteamCMD
RUN apt-get install --no-install-recommends -y \
    ca-certificates \
    software-properties-common \
    python-software-properties \
    lib32gcc1 \
    xvfb \
    curl \
    wget \
    telnet \
    expect

# Run as root
USER root

# Setup the default timezone
ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create and set the steamcmd folder as a volume
RUN mkdir -p /steamcmd/7dtd
VOLUME ["/steamcmd/7dtd"]

# Install NodeJS (see below)
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# Setup scheduling support
ADD scheduler_app/ /scheduler_app/
WORKDIR /scheduler_app
RUN npm install
WORKDIR /

# Add the steamcmd installation script
ADD install.txt /install.txt

# Copy scripts
ADD start_7dtd.sh /start.sh
ADD shutdown.sh /shutdown.sh
ADD update_check.sh /update_check.sh

# Copy the default server config in place
ADD serverconfig_original.xml /serverconfig.xml

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
ENV SEVEN_DAYS_TO_DIE_TELNET_PORT 8081
ENV SEVEN_DAYS_TO_DIE_TELNET_PASSWORD ""
ENV SEVEN_DAYS_TO_DIE_START_MODE "0"
ENV SEVEN_DAYS_TO_DIE_UPDATE_CHECKING "0"
ENV SEVEN_DAYS_TO_DIE_UPDATE_BRANCH "public"

# Start the server
ENTRYPOINT ["./start.sh"]
