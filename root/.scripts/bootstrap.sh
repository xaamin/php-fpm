#!/bin/bash

LOGS="${SHARED_VOLUME}/server/log/${ACCOUNT:=$(hostname)}"
PHPPID="/run/php"

# Create log directory
if [[ ! -d "$LOGS" ]]; then
    echo "Creating log dir..."

    mkdir -p "$LOGS"

    echo "Log dir created"
    echo ""
fi

# Create path for PID file
if [[ ! -d "$PHPPID" ]]; then
    echo "Creating PHP FPM PID dir..."

    mkdir "$PHPPID"

    echo "Created PHP FPM PID dir..."
fi

/bin/bash /root/.scripts/fix-permissions.sh || true

if [[ ! -f "${LOGS}/permission-fixes.lock" ]]; then
    /bin/bash /root/.scripts/apply-permissions.sh || true

    touch "${LOGS}/permission-fixes.lock"

    echo "Created lock file to avoid apply permissions on every container start"
else
    echo "Permissions fixes was done previously. Run the  apply-permissions.sh script after delete the permission-fixes.lock file"
    echo "PHP FPM PID dir created"
    echo ""
fi

sed -i 's|error_log =.*|error_log = '${LOGS}'/php-fpm.log|' /etc/php/7.4/fpm/php-fpm.conf || true
sed -i 's|;\?php_admin_value\[error_log\] =.*|php_admin_value\[error_log\] = '${LOGS}'/php-fpm.www.log|' /etc/php/7.4/fpm/pool.d/www.conf || true

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
