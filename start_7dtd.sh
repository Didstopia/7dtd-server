#!/usr/bin/env bash

# Enable debugging
#set -x

child=0

trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM
exit_handler()
{
	echo "Shut down signal received.."
	/shutdown.sh
	sleep 6
	echo "Forcefully terminating if necessary.."
	sleep 1
	kill $child 2>/dev/null
	wait $child 2>/dev/null
	exit
}

# 7 Days to Die includes a 64-bit version of steamclient.so, so we need to tell the OS where it exists
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/steamcmd/7dtd/7DaysToDieServer_Data/Plugins/x86_64

# Fix issues with libcurl
#export LD_PRELOAD=$LD_PRELOAD:/usr/lib/libcurl.so

# Define the install/update function
install_or_update()
{
	# Install 7 Days to Die from install.txt
	echo "Installing/updating 7 Days to Die.. (this might take a while, be patient)"
	/steamcmd/steamcmd.sh +runscript /install.txt

	# Terminate if exit code wasn't zero
	if [ $? -ne 0 ]; then
		echo "Exiting, steamcmd install or update failed!"
		exit 1
	fi
}

# Check which branch to use
if [ ! -z ${SEVEN_DAYS_TO_DIE_BRANCH+x} ]; then
	echo "Using branch arguments: $SEVEN_DAYS_TO_DIE_BRANCH"

	# Add "-beta" if necessary
	INSTALL_BRANCH="${SEVEN_DAYS_TO_DIE_BRANCH}"
	if [ ! "$SEVEN_DAYS_TO_DIE_BRANCH" == "public" ]; then
		INSTALL_BRANCH="-beta ${SEVEN_DAYS_TO_DIE_BRANCH}"
	fi
	sed -i "s/app_update 294420.*validate/app_update 294420 $INSTALL_BRANCH validate/g" /install.txt
else
	sed -i "s/app_update 294420.*validate/app_update 294420 validate/g" /install.txt
fi

# Disable auto-update if start mode is 2
if [ "$SEVEN_DAYS_TO_DIE_START_MODE" = "2" ]; then
	# Check that 7 Days to Die exists in the first place
	if [ ! -f "/steamcmd/7dtd/7DaysToDieServer.x86_64" ]; then
		install_or_update
	else
		echo "7 Days to Die seems to be installed, skipping automatic update.."
	fi
else
	install_or_update

	# Run the update check if it's not been run before
	if [ ! -f "/steamcmd/7dtd/build.id" ]; then
		/update_check.sh
	else
		OLD_BUILDID="$(cat /steamcmd/7dtd/build.id)"
		STRING_SIZE=${#OLD_BUILDID}
		if [ "$STRING_SIZE" -lt "6" ]; then
			/update_check.sh
		fi
	fi
fi

# Start mode 1 means we only want to update
if [ "$SEVEN_DAYS_TO_DIE_START_MODE" = "1" ]; then
	echo "Exiting, start mode is 1.."
	exit
fi

# Start cron
echo "Starting scheduled task manager.."
node /scheduler_app/app.js &

# Set the working directory
cd /steamcmd/7dtd

# Validate that the default server configuration file exists
if [ ! -f "/steamcmd/7dtd/serverconfig.xml" ]; then
	echo "ERROR: Default server configuration file not found, are you sure the server is up to date?"
	exit 1
fi

# Copy the default config file if one doesn't yet exist
if [ ! -f "${SEVEN_DAYS_TO_DIE_CONFIG_FILE}" ]; then
	echo "Config file not found, creating a new one.."
	cp /steamcmd/7dtd/serverconfig.xml ${SEVEN_DAYS_TO_DIE_CONFIG_FILE}
fi

# Run the server
exec /steamcmd/7dtd/7DaysToDieServer.x86_64 ${SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS} -configfile=${SEVEN_DAYS_TO_DIE_CONFIG_FILE} &

child=$!
wait "$child"
