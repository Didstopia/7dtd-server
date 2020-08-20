FROM didstopia/base:nodejs-12-steamcmd-ubuntu-18.04

LABEL maintainer="Didstopia <support@didstopia.com>"

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
    xvfb \
    telnet \
    expect && \
    rm -rf /var/lib/apt/lists/*

# Create the volume directories
RUN mkdir -p /steamcmd/7dtd /app/.local/share/7DaysToDie

# Setup scheduling support
ADD scheduler_app/ /app/scheduler_app/
WORKDIR /app/scheduler_app
RUN npm install
WORKDIR /

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy scripts
ADD start_7dtd.sh /app/start.sh
ADD shutdown.sh /app/shutdown.sh
ADD update_check.sh /app/update_check.sh

# Fix permissions
RUN chown -R 1000:1000 \
    /steamcmd \
    /app

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 26900/tcp
EXPOSE 26900/udp
EXPOSE 26901/udp
EXPOSE 26902/udp
EXPOSE 8080/tcp
EXPOSE 8081/tcp

# Setup default environment variables for the server
ENV SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS "-quit -batchmode -nographics -dedicated"
ENV SEVEN_DAYS_TO_DIE_CONFIG_FILE "/app/.local/share/7DaysToDie/serverconfig.xml"
ENV SEVEN_DAYS_TO_DIE_TELNET_PORT 8081
ENV SEVEN_DAYS_TO_DIE_TELNET_PASSWORD ""
ENV SEVEN_DAYS_TO_DIE_BRANCH "public"
ENV SEVEN_DAYS_TO_DIE_START_MODE "0"
ENV SEVEN_DAYS_TO_DIE_UPDATE_CHECKING "0"

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

# Expose the volumes
VOLUME [ "/steamcmd/7dtd", "/app/.local/share/7DaysToDie" ]

# Start the server
CMD [ "bash", "/app/start.sh" ]
