Docker Image for GMVault
========================


Overview
--------

A Docker image that runs Gmvault on a regular basis, with both quick (daily) and
full (weekly) synchronization schedules. Emails out sync reports through ssmtp.

```
docker run \
	-v /my/backup/directory:/data \
	-v /my/host/ssmtp.conf:/etc/ssmtp/ssmtp.conf \
	-t \
	-d \
	--name=Gmvault \
	-e GMVAULT_UID=$(id -u myuser) \
	-e GMVAULT_GID=$(id -g mygroup) \
	-e GMVAULT_EMAIL_ADDRESS="myaddress@gmail.com" \
	aubertg/gmvault-docker
```


Running this container for the first time
-----------------------------------------

Gmvault requires authenticated access to the account you want to back up. To
that effect, you will need to go through the following set up the first time
you run this container:

1. Attach a terminal to your container.
2. Run this command: `su -c 'gmvault sync -d /data ${GMVAULT_EMAIL_ADDRESS}' gmvault`
3. Go to the URL indicated, and copy the token back.
4. Once the synchronization process starts, restart the container.


Volumes
-------

The container requires the following volumes to be attached in order to work
properly:

* **`/data`**  
	Where the OAuth token, email backups, and logs will be stored.

* **`/etc/ssmtp/ssmtp.conf`**  
	A ssmtp config file to send emails reports from the Docker container.

	Example for Gmail:
	```
	# Settings for Gmail SMTP service.
	mailhub=smtp.gmail.com:587
	hostname=smtp.gmail.com:587
	UseSTARTTLS=YES
	FromLineOverride=YES

	# Gmail account.
	root=mygmailaddress@gmail.com
	AuthUser=mygmailaddress@gmail.com
	AuthPass=mypassword
	```


Environment Variables
---------------------

The container is configurable through the following environment variables:

* **`GMVAULT_EMAIL_ADDRESS`** *(required)*  
	The email address of the account to back up.

* **`GMVAULT_SEND_REPORTS_TO`** *(optional)*  
	The email address to send reports to; defaults to `GMVAULT_EMAIL_ADDRESS`.

* **`GMVAULT_UID`** *(optional)*  
	Numeric uid in the host that should own created files; defaults to 9000.

* **`GMVAULT_GID`** *(optional)*  
	Numeric gid in the host that should own created files; defaults to 9000.

* **`GMVAULT_TIMEZONE`** *(optional)*  
	Timezone; defaults to America/Los_Angeles.

* **`GMVAULT_OPTIONS`** *(optional)*  
	Additional options to pass to gmvault (such as `--c no`).

* **`GMVAULT_QUICK_SYNC_SCHEDULE`** *(optional)*  
	Custom quick sync schedule; defaults to daily.

* **`GMVAULT_FULL_SYNC_SCHEDULE`** *(optional)*  
	Custom full sync schedule; defaults to weekly.

* **`GMVAULT_SYNC_ON_STARTUP`** *(optional)*  
	Set to `yes` to trigger a sync when the container starts, in addition to the
	normal cron schedule.


Thanks
------

* Thank you [https://github.com/gaubert](Guillaume Aubert) for developing
[https://github.com/gaubert/gmvault](Gmvault)!

* Thank you [https://github.com/jdhorne](Jason Horne) for publishing
[https://github.com/jdhorne/gmvault-docker](jdhorne/gmvault-docker)! I learned
a lot from your architecture before building my own image.


Copyright
---------

Copyright (C) 2017 Guillaume Aubert.


License
-------

This software is released under the MIT license. See the LICENSE file for
details.


Disclaimer
----------

I am providing code in this repository to you under an open source license.
Because this is my personal repository, the license you receive to my code is
from me and not from my employer (Facebook).
