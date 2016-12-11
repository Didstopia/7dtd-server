#!/usr/bin/env bash

set -m

# Check if we are auto-updating or not
if [ "$SEVEN_DAYS_TO_DIE_UPDATE_CHECKING" = "1" ]; then
	echo "Checking Steam for updates.."
else
	exit
fi

# Get the old build id (default to 0)
OLD_BUILDID=0
if [ -f "/steamcmd/7dtd/build.id" ]; then
	OLD_BUILDID="$(cat /steamcmd/7dtd/build.id)"
fi

# Minimal validation for the update branch
STRING_SIZE=${#SEVEN_DAYS_TO_DIE}
if [ "$STRING_SIZE" -lt "1" ]; then
	SEVEN_DAYS_TO_DIE=public
fi

# Remove the old cached app info if it exists
if [ -f "/root/Steam/appcache/appinfo.vdf" ]; then
	rm -fr /root/Steam/appcache/appinfo.vdf
fi

# Get the new build id directly from Steam
NEW_BUILDID="$(./steamcmd/steamcmd.sh +login anonymous +app_info_update 1 +app_info_print "258550" +quit | grep -EA 1000 "^\s+\"branches\"$" | grep -EA 5 "^\s+\"$SEVEN_DAYS_TO_DIE\"$" | grep -m 1 -EB 10 "^\s+}$" | grep -E "^\s+\"buildid\"\s+" | tr '[:blank:]"' ' ' | tr -s ' ' | sed "s/ buildid //g" | xargs)"

# Check that we actually got a new build id
STRING_SIZE=${#NEW_BUILDID}
if [ "$STRING_SIZE" -lt "6" ]; then
	echo "Error getting latest server build id from Steam, automatic updates disabled.."
	exit
fi

# Skip update checking if this is the first time
if [ ! -f "/steamcmd/7dtd/build.id" ]; then
	echo "First time running update check (server build id not found), skipping update.."
	echo $NEW_BUILDID > /steamcmd/7dtd/build.id
	exit
else
	STRING_SIZE=${#OLD_BUILDID}
	if [ "$STRING_SIZE" -lt "6" ]; then
		echo "First time running update check (server build id empty), skipping update.."
		echo $NEW_BUILDID > /steamcmd/7dtd/build.id
		exit
	fi
fi

# Check if the builds match and quit if so
if [ "$OLD_BUILDID" = "$NEW_BUILDID" ]; then
	echo "Build id $OLD_BUILDID is already the latest, skipping update.."
	exit
else
	echo "Latest server build id ($NEW_BUILDID) is newer than the current one ($OLD_BUILDID), waiting for client update.."
	echo $NEW_BUILDID > /steamcmd/7dtd/build.id
	expect /shutdown.sh
	exit
fi
