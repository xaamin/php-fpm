#!/bin/bash
source .env

docker build -t ${TAG} --no-cache --build-arg tz=${TZ} --build-arg php_version=${PHP_VERSION} .
