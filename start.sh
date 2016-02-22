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

/usr/bin/supervisord -n