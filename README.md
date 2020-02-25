## PHP FPM Dockerfile
This repository contains **Dockerfile** of PHP7.4-FPM Docker's [automated build](https://hub.docker.com/r/xaamin/php-fpm)

### Base docker image
* [xaamin/php-cli](https://registry.hub.docker.com/r/xaamin/php)

### Installation
* Install [Docker](https://www.docker.com)
* Pull from [Docker Hub](https://hub.docker.com/r/xaamin/php-fpm) `docker pull xaamin/php-fpm:7.4`

### Usage
```
	docker run -d -name "php-fpm7.4" --restart always -v /path/with/php/files:/shared xaamin/php-fpm:7.4
```