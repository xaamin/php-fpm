#!/bin/bash

LOGS="/shared/accounts/${ACCOUNT:=$(hostname)}/logs"
PHPPID="/run/php"

# Create logs directory
if [[ ! -d "$LOGS" ]]; then
	echo "Creating log dir..."
	echo ""
	mkdir -p "$LOGS"
	echo "Log dir created"
	echo ""
fi

# Create path for PID file
if [[ ! -d "$PHPPID" ]]; then
	echo "Creating PHP FPM PID dir..."
	echo ""
	mkdir "$PHPPID"
fi

sed -i 's|error_log =.*|error_log = /shared/accounts/'${ACCOUNT:=$(hostname)}'/logs/php7.0-fpm.error.log|' /etc/php/7.0/fpm/php-fpm.conf

/usr/bin/supervisord -n