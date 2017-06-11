#!/bin/bash

echo "Starting quick sync of $GMVAULT_EMAIL_ADDRESS."
echo "Report will be sent to $GMVAULT_SEND_REPORTS_TO."

gmvault sync -t quick -d /data $GMVAULT_OPTIONS $GMVAULT_EMAIL_ADDRESS 2>&1 \
	| tee /data/${GMVAULT_EMAIL_ADDRESS}_quick.log \
	| mail -s "Mail Backup (quick) | $GMVAULT_EMAIL_ADDRESS | `date +'%Y-%m-%d %r %Z'`" $GMVAULT_SEND_REPORTS_TO

echo "Quick sync complete."
