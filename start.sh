#!/bin/bash

OAUTH_TOKEN="/data/${GMVAULT_EMAIL_ADDRESS}.oauth2"

if [ "$GMVAULT_OPTIONS" != "" ]; then
	echo "Gmvault will run with the following additional options: $GMVAULT_OPTIONS."
fi

# Ensure there's an address to send reports to.
GMVAULT_SEND_REPORTS_TO=${GMVAULT_SEND_REPORTS_TO:="$GMVAULT_EMAIL_ADDRESS"}
echo "Sending email reports to $GMVAULT_SEND_REPORTS_TO."

# Adjust timezone.
GMVAULT_TIMEZONE=${GMVAULT_TIMEZONE:="America/Los_Angeles"}
cp /usr/share/zoneinfo/${GMVAULT_TIMEZONE} /etc/localtime
echo ${GMVAULT_TIMEZONE} > /etc/timezone
echo "Date: `date`."

# Set up Gmvault group.
GMVAULT_GID=${GMVAULT_GID:="$GMVAULT_DEFAULT_GID"}
if [ "$(id -g gmvault)" != "$GMVAULT_GID" ]; then
	groupmod -o -g "$GMVAULT_GID" gmvault
fi
echo "Using group ID $(id -g gmvault)."

# Set up Gmvault user.
GMVAULT_UID=${GMVAULT_UID:="$GMVAULT_DEFAULT_UID"}
if [ "$(id -u gmvault)" != "$GMVAULT_UID" ]; then
	usermod -o -u "$GMVAULT_UID" gmvault
fi
echo "Using user ID $(id -u gmvault)."

# Make sure the files are owned by the user executing Gmvault, as we will need
# to add/delete files.
chown -R gmvault:gmvault /data

# Set up crontab.
echo "" > $CRONTAB
echo "${GMVAULT_FULL_SYNC_SCHEDULE} /app/backup_full.sh" >> $CRONTAB
echo "${GMVAULT_QUICK_SYNC_SCHEDULE} /app/backup_quick.sh" >> $CRONTAB

# Start app.
if [ -f $OAUTH_TOKEN ]; then
	echo "Using OAuth token found at $OAUTH_TOKEN."

	if [ "$GMVAULT_SYNC_ON_STARTUP" == "yes" ]; then
		if [ -d /data/db ]; then
			echo "Existing database directory found, running quick sync."
			su-exec gmvault "/app/backup_quick.sh"
		else
			echo "No existing database found, running full sync."
			su-exec gmvault "/app/backup_full.sh"
		fi
	else
		echo "No sync on startup, see GMVAULT_SYNC_ON_STARTUP if you would like to change this."
	fi

	crond -f
fi

echo "#############################"
echo "#   OAUTH SETUP REQUIRED!   #"
echo "#############################"
echo ""
echo "No Gmail OAuth token found at $OAUTH_TOKEN."
echo "Please set it up with the following instructions:"
echo "  1/ Attach a terminal to your container."
echo "  2/ Run this command:"
echo "     su -c 'gmvault sync -d /data $GMVAULT_EMAIL_ADDRESS' gmvault"
echo "  3/ Go to the URL indicated, and copy the token back."
echo "  4/ Once the synchronization process starts, restart the container."

/bin/bash
