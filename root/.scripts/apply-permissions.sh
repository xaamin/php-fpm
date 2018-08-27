#!/usr/bin/env bash
set -e

# Apply permissions.
echo "Setting permissions for all the www directories..."

find ${SHARED_VOLUME}/shared/web/ -maxdepth 1 -type d | grep -v .git | xargs chown -R $DOCKER_USER:$DOCKER_GROUP || true

echo "Applied permissions to all the www directories."