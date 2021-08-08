#!/bin/bash

echo "Starting quick sync of $GMVAULT_EMAIL_ADDRESS."
echo "Report will be sent to $GMVAULT_SEND_REPORTS_TO."

LOGFILE="/data/${GMVAULT_EMAIL_ADDRESS}_quick.log"

gmvault sync -t quick -d /data $GMVAULT_OPTIONS $GMVAULT_EMAIL_ADDRESS 2>&1 > $LOGFILE

if [ "$GMVAULT_EMAIL_REPORT" != "no" ]
then
    cat $LOGFILE | mail -s "Mail Backup (quick) | $GMVAULT_EMAIL_ADDRESS | `date +'%Y-%m-%d %r %Z'`" $GMVAULT_SEND_REPORTS_TO
fi

echo "Quick sync complete."
