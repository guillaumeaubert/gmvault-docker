FROM alpine:latest

# GMVAULT_DIR allows using a location that is not the default $HOME/.gmvault.
ENV GMVAULT_DIR="/data" \
	GMVAULT_EMAIL_ADDRESS="test@example.com" \
	GMVAULT_FULL_SYNC_SCHEDULE="1 3 * * 0" \
	GMVAULT_QUICK_SYNC_SCHEDULE="1 2 * * 1-6" \
	GMVAULT_DEFAULT_GID="9000" \
	GMVAULT_DEFAULT_UID="9000" \
	CRONTAB="/var/spool/cron/crontabs/gmvault"

VOLUME $GMVAULT_DIR
RUN mkdir /app

# Set up environment.
RUN apk add --update \
		bash \
		ca-certificates \
		mailx \
		py-pip \
		python \
		ssmtp \
		shadow \
		su-exec \
		tzdata \
	&& pip install --upgrade pip \
	&& pip install gmvault \
	&& rm -rf /var/cache/apk/* \
	&& addgroup -g "$GMVAULT_DEFAULT_GID" gmvault \
	&& adduser \
		-H `# No home directory` \
		-D `# Don't assign a password` \
		-u "$GMVAULT_DEFAULT_UID" \
		-s "/bin/bash" \
		-G "gmvault" \
		gmvault

# Copy cron jobs.
COPY backup_quick.sh /app/
COPY backup_full.sh /app/

# Set up entry point.
COPY start.sh /app/
WORKDIR /app
ENTRYPOINT ["/app/start.sh"]
