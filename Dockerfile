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
    wget

# Run as root
USER root

# Install supervisor
RUN apt-get install -y supervisor && \
	mkdir -p /etc/supervisor/conf.d/ && \
	mkdir -p /var/log/supervisor/

# Copy supervisor configuration file
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Setup supervisor permissions
RUN touch /var/log/supervisor/7dtd.out.log && touch /var/log/supervisor/7dtd.err.log
RUN chown -R root:root /var/log/supervisor/7dtd.*.log

# Install SteamCMD
RUN mkdir -p /steamcmd/7dtd && \
	curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /steamcmd -zx

# Setup symlinks
RUN mkdir -p /7dtd_data && ln -s /7dtd_data /steamcmd/7dtd/server_data

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

# Enable the data volume
VOLUME ["/7dtd_data"]

# Expose necessary ports
EXPOSE 26900
EXPOSE 25000
EXPOSE 25001
EXPOSE 25002
EXPOSE 25003
EXPOSE 8080
EXPOSE 8081

# Setup default environment variables for the server
ENV SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS "-configfile=server_data/serverconfig.xml -logfile server_data/7dtd.log -quit -batchmode -nographics -dedicated"

# Start supervisord
CMD supervisord -n -c /etc/supervisor/supervisord.conf
