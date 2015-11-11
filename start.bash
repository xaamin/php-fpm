#!/bin/bash

OVERRIDE="/data"
LOGS="logs"

# Create logs directory
if [[ ! -d "$OVERRIDE/$LOGS" ]]; then
	mkdir -p "$OVERRIDE/$LOGS"
fi


# Configure and secure PHP
sed -i 's|date.timezone =.*|date.timezone = '${DATE_TIMEZONE}'|' /etc/php5/cli/php.ini
sed -i 's|date.timezone =.*|date.timezone = '${DATE_TIMEZONE}'|' /etc/hhvm/php.ini
sed -i 's|max_execution_time =.*|max_execution_time = '${REQUEST_TIMEOUT}'|' /etc/hhvm/php.ini
sed -i 's|max_input_time =.*|max_input_time = '${MAX_INPUT_TIME}'|' /etc/hhvm/php.ini
sed -i 's|memory_limit =.*|memory_limit = '${MEMORY_LIMIT}'|' /etc/hhvm/php.ini
sed -i 's|upload_max_filesize =.*|upload_max_filesize = '${POST_MAX_SIZE}'|' /etc/hhvm/php.ini
sed -i 's|post_max_size =.*|post_max_size = '${POST_MAX_SIZE}'|' /etc/hhvm/php.ini
sed -i 's|short_open_tag =.*|short_open_tag = On|' /etc/hhvm/php.ini
sed -i 's|hhvm.server.connection_timeout_seconds =.*|hhvm.server.connection_timeout_seconds = '${REQUEST_TIMEOUT}'|' /etc/hhvm/server.ini
sed -i 's|hhvm.server.request_timeout_seconds =.*|hhvm.server.request_timeout_seconds = '${REQUEST_TIMEOUT}'|' /etc/hhvm/server.ini

/usr/bin/supervisord -n