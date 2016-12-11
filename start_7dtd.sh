#!/usr/bin/env bash

child=0

trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM
exit_handler()
{
	echo "Shut down signal received.."
	expect /shutdown.sh
	sleep 6
	echo "Force quitting.."
	sleep 1
	kill $child
	exit
}

# Create the necessary folder structure
if [ ! -d "/steamcmd/7dtd/server_data" ]; then
	echo "Creating folder structure.."
	mkdir -p /steamcmd/7dtd/server_data
	echo "Copying default server configuration.."
	cp /serverconfig.xml /steamcmd/7dtd/server_data/serverconfig.xml
	echo "Creating an empty log file.."
	touch /steamcmd/7dtd/server_data/7dtd.log
fi

# Install/update steamcmd
echo "Installing/updating steamcmd.."
curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C /steamcmd -zx

# Disable auto-update if start mode is 2
if [ "$SEVEN_DAYS_TO_DIE_START_MODE" = "2" ]; then
	# Check that 7 Days to Die exists in the first place
	if [ ! -f "/steamcmd/7dtd/7DaysToDieServer.x86_64" ]; then
		# Install 7 Days to Die from install.txt
		echo "Installing/updating 7 Days to Die.. (this might take a while, be patient)"
		STEAMCMD_OUTPUT=$(bash /steamcmd/steamcmd.sh +runscript /install.txt | tee /dev/stdout)
		STEAMCMD_ERROR=$(echo $STEAMCMD_OUTPUT | grep -q 'Error')
		if [ ! -z "$STEAMCMD_ERROR" ]; then
			echo "Exiting, steamcmd install or update failed: $STEAMCMD_ERROR"
			exit
		fi
	else
		echo "7 Days to Die seems to be installed, skipping automatic update.."
	fi
else
	# Install/update 7 Days to Die from install.txt
	echo "Installing/updating 7 Days to Die.. (this might take a while, be patient)"
	STEAMCMD_OUTPUT=$(bash /steamcmd/steamcmd.sh +runscript /install.txt | tee /dev/stdout)
	STEAMCMD_ERROR=$(echo $STEAMCMD_OUTPUT | grep -q 'Error')
	if [ ! -z "$STEAMCMD_ERROR" ]; then
		echo "Exiting, steamcmd install or update failed: $STEAMCMD_ERROR"
		exit
	fi

	# Run the update check if it's not been run before
	if [ ! -f "/steamcmd/7dtd/build.id" ]; then
		./update_check.sh
	else
		OLD_BUILDID="$(cat /steamcmd/7dtd/build.id)"
		STRING_SIZE=${#OLD_BUILDID}
		if [ "$STRING_SIZE" -lt "6" ]; then
			./update_check.sh
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

# Run the server
echo "Starting 7 Days to Die.."
/steamcmd/7dtd/7DaysToDieServer.x86_64 ${SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS} &

child=$!
wait "$child"
