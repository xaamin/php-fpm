#!/bin/bash

LOGS="/shared/web/${ACCOUNT:=$(hostname)}/logs"
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


/bin/bash /root/.scripts/fix-permissions.sh || true

if [[ ! -f "/shared/web/${ACCOUNT:=$(hostname)}/permission-fixes.lock" ]]; then
    /bin/bash /root/.scripts/apply-permissions.sh || true

    touch "/shared/web/${ACCOUNT:=$(hostname)}/permission-fixes.lock"

    echo "Created lock file to avoid apply permissions on every container start"
else
    echo "Permissions fixes was done previously. Run the  apply-permissions.sh script after delete the permission-fixes.lock file"
fi

sed -i 's|error_log =.*|error_log = /shared/web/'${ACCOUNT:=$(hostname)}'/logs/php5.6-fpm.error.log|' /etc/php/5.6/fpm/php-fpm.conf

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf