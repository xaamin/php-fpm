FROM xaamin/php

MAINTAINER "Benjamín Martínez Mateos" <bmxamin@gmail.com>

# Install PHP-FPM
RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        php5-fpm \
        php5-xdebug \
        php5-xmlrpc \
        php5-xcache \
        libfcgi0ldbl \

    # Remove temp files
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure and secure PHP
RUN sed -i "s/;date.timezone =.*/date.timezone = $\(DATE_TIMEZONE\)/" /etc/php5/fpm/php.ini && \
    sed -i "s/max_execution_time =.*/max_execution_time = $\(REQUEST_TIMEOUT\)/" /etc/php5/fpm/php.ini && \
    sed -i "s/;request_terminate_timeout =.*/request_terminate_timeout = $\(REQUEST_TIMEOUT\)/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "s/max_input_time =.*/max_input_time = $\(MAX_INPUT_TIME\)/" /etc/php5/fpm/php.ini && \
    sed -i "s/memory_limit =.*/memory_limit = $\(MEMORY_LIMIT\)/" /etc/php5/fpm/php.ini && \
    sed -i "s/upload_max_filesize =.*/upload_max_filesize = $\(UPLOAD_MAX_FILESIZE\)/" /etc/php5/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo =.*/cgi.fix_pathinfo = 0/" /etc/php5/fpm/php.ini && \
    sed -i "s/short_open_tag =.*/short_open_tag = On/" /etc/php5/fpm/php.ini && \
    sed -i "s/^[;]\?daemonize =.*/daemonize = no/" /etc/php5/fpm/php-fpm.conf && \
    sed -i "s/^listen =.*/listen = 0.0.0.0:9000/" /etc/php5/fpm/pool.d/www.conf && \    
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php5/fpm/php.ini && \
    sed -i "s/^[;]\?listen.allowed_clients =.*/;listen.allowed_clients =/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "s/^[;]\?catch_workers_output =.*/catch_workers_output = yes/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "s/;pm.status_path =.*/pm.status_path = \/status/" /etc/php5/fpm/pool.d/www.conf 

RUN echo "php_admin_value[display_errors] = stderr" >> /etc/php5/fpm/pool.d/www.conf

# Defines the default timezone used by the date functions
ENV DATE_TIMEZONE America/Mexico_City

# Maximum execution time of each script, in seconds (php.ini)

# The timeout for serving a single request after which the worker process will
# be killed. This option should be used when the 'max_execution_time' ini option
# does not stop script execution for some reason. A value of '0' means 'off'.
# Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
# (www.conf)
ENV REQUEST_TIMEOUT 30

# Maximum amount of time each script may spend parsing request data. It's a good
# idea to limit this time on productions servers in order to eliminate unexpectedly
# long running scripts.
ENV MAX_INPUT_TIME 60

# Maximum amount of memory a script may consume (128MB)
ENV MEMORY_LIMIT 128MB

# Maximum allowed size for uploaded files.
ENV UPLOAD_MAX_FILESIZE 30MB

# Add supervisor config file
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Define mountable directories
VOLUME ["/data"]

# Port 9000 is how Nginx will communicate with PHP-FPM.
EXPOSE 9000

# Run PHP-FPM through Supervisor.
CMD ["/usr/bin/supervisord", "-n"]