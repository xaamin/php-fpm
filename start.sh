#!/bin/bash

LOGS="/shared/logs"

# Create logs directory
if [[ ! -d "$LOGS" ]]; then
	echo "Creating log dir..."
	echo ""
	mkdir -p "$LOGS"
	echo "Log dir created"
	echo ""
fi

sed -i 's|error_log =.*|error_log = /shared/logs/'${LOG_ALIAS:=$(hostname)}'.fpm.error.log|' /etc/php5/fpm/php-fpm.conf

/usr/bin/supervisord -n