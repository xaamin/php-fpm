ARG tz='UTC'
ARG php_version='8.3'

FROM xaamin/php-cli:$php_version
LABEL maintainer="Benjamín Martínez Mateos <xaamin@outlook.com>"

ARG tz
ARG php_version

ENV TZ $tz

ENV DOCKER_USER www-data
ENV DOCKER_GROUP www-data

ENV HOST_USER_ID 21338
ENV HOST_GROUP_ID 21337

# The timeout for serving a single request after which the worker process will
# be killed. This option should be used when the 'max_execution_time' ini option
# does not stop script execution for some reason. A value of '0' means 'off'.
# Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
# (www.conf)
ENV REQUEST_TIMEOUT 60

# Maximum amount of time each script may spend parsing request data. It's a good
# idea to limit this time on productions servers in order to eliminate unexpectedly
# long running scripts.
ENV MAX_INPUT_TIME 60

# Maximum amount of memory a script may consume (64MB)
ENV MEMORY_LIMIT 64M

# Maximum allowed size for uploaded files.
ENV POST_MAX_SIZE 5M

# Add supervisor config file
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Add bootstrap file
ADD root/.scripts /root/.scripts

# Install PHP-FPM
RUN set -xe \
    && echo $TZ > /etc/timezone \
    && apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        php$php_version-fpm \
        libfcgi0ldbl \
    # Remove temp files
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure and secure PHP
RUN sed -i 's|;\?date.timezone =.*|date.timezone = ${TZ}|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|;\?date.timezone =.*|date.timezone = ${TZ}|' /etc/php/$php_version/cli/php.ini \
    && sed -i 's|max_execution_time =.*|max_execution_time = ${REQUEST_TIMEOUT}|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|;\?request_terminate_timeout =.*|request_terminate_timeout = ${REQUEST_TIMEOUT}|' /etc/php/$php_version/fpm/pool.d/www.conf \
    && sed -i 's|max_input_time =.*|max_input_time = ${MAX_INPUT_TIME}|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|memory_limit =.*|memory_limit = ${MEMORY_LIMIT}|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|upload_max_filesize =.*|upload_max_filesize = ${POST_MAX_SIZE}|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|post_max_size =.*|post_max_size = ${POST_MAX_SIZE}|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|;\?cgi.fix_pathinfo =.*|cgi.fix_pathinfo = 0|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|short_open_tag =.*|short_open_tag = On|' /etc/php/$php_version/fpm/php.ini \
    && sed -i 's|;\?daemonize =.*|daemonize = no|' /etc/php/$php_version/fpm/php-fpm.conf \
    && sed -i 's|;\?listen =.*|listen = 0.0.0.0:9000|' /etc/php/$php_version/fpm/pool.d/www.conf \
    && sed -i 's|;\?pm.status_path =.*|pm.status_path = /status|' /etc/php/$php_version/fpm/pool.d/www.conf \
    && sed -i 's|;\?listen.allowed_clients =.*|;listen.allowed_clients =|' /etc/php/$php_version/fpm/pool.d/www.conf \
    && sed -i 's|;\?catch_workers_output =.*|catch_workers_output = yes|' /etc/php/$php_version/fpm/pool.d/www.conf \
    && sed -i 's|;\?php_admin_flag\[log_errors\] =.*|php_admin_flag\[log_errors\] = on|' /etc/php/$php_version/fpm/pool.d/www.conf

RUN sed -i "s|fpm-version|php-fpm${php_version}|" /etc/supervisor/supervisord.conf \
    && sed -i "s|php-version|${php_version}|g" /root/.scripts/bootstrap.sh

# Port 9000 is how Nginx will communicate with PHP-FPM.
EXPOSE 9000

# Define default command.
CMD ["/bin/bash", "/root/.scripts/bootstrap.sh"]