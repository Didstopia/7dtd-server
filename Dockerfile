FROM didstopia/base:nodejs-steamcmd-ubuntu-16.04

LABEL maintainer="Didstopia <support@didstopia.com>"

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
    xvfb \
    curl \
    wget \
    telnet \
    expect && \
    rm -rf /var/lib/apt/lists/*

# Run as root
USER root

# Create and define volumes
RUN mkdir -p /steamcmd/7dtd /root/.local/share/7DaysToDie
VOLUME ["/steamcmd/7dtd", "/root/.local/share/7DaysToDie"]

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

# Expose necessary ports
EXPOSE 26900/tcp
EXPOSE 26900/udp
EXPOSE 26901/udp
EXPOSE 26902/udp
EXPOSE 8080/tcp
EXPOSE 8081/tcp

# Setup default environment variables for the server
ENV SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS "-logfile /dev/stdout -quit -batchmode -nographics -dedicated"
ENV SEVEN_DAYS_TO_DIE_CONFIG_FILE "/root/.local/share/7DaysToDie/serverconfig.xml"
ENV SEVEN_DAYS_TO_DIE_TELNET_PORT 8081
ENV SEVEN_DAYS_TO_DIE_TELNET_PASSWORD ""
ENV SEVEN_DAYS_TO_DIE_START_MODE "0"
ENV SEVEN_DAYS_TO_DIE_UPDATE_CHECKING "0"
ENV SEVEN_DAYS_TO_DIE_UPDATE_BRANCH "public"

# Start the server
ENTRYPOINT ["./start.sh"]
