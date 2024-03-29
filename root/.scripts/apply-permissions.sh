#!/usr/bin/env bash
set -e

if [ ! -z "$SHARED_VOLUME" ]; then
    # Apply permissions.
    echo "Setting permissions for all the www directories..."

    find ${SHARED_VOLUME}/web/ | grep -v .git | xargs chown -R $DOCKER_USER:$DOCKER_GROUP || true

    echo "Applied permissions to all the www directories."
fi