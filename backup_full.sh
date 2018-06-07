#!/bin/bash

echo "Starting full sync of $GMVAULT_EMAIL_ADDRESS."
echo "Report will be sent to $GMVAULT_SEND_REPORTS_TO."

gmvault sync -d /data $GMVAULT_OPTIONS $GMVAULT_EMAIL_ADDRESS 2>&1 \
	| tee /data/${GMVAULT_EMAIL_ADDRESS}_full.log \
	| mail -s "Mail Backup (full) | $GMVAULT_EMAIL_ADDRESS | `date +'%Y-%m-%d %r %Z'`" $GMVAULT_SEND_REPORTS_TO

echo "Full sync complete."
