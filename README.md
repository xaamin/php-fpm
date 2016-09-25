## PHP FPM Dockerfile
This repository contains **Dockerfile** of PHP7.0-FPM Docker's [automated build](https://hub.docker.com/r/xaamin/php-fpm)

### Base docker image
* [xaamin/php-cli](https://registry.hub.docker.com/r/xaamin/php)

### Installation
* Install [Docker](https://www.docker.com)
* Pull from [Docker Hub](https://hub.docker.com/r/xaamin/php-fpm) `docker pull xaamin/php-fpm:7.0`

### Manual build
* Build an image from Dockerfile `docker build -t xaamin/php-fpm:7.0 https://github.com/xaamin/php-fpm.git`

### Volumes
You must provide a volume mounted on /shared containing all files to serve

### Usage
```
	docker run -d -name "php-fpm.server" --restart always -v /path/with/php/files:/shared xaamin/php-fpm:7.0
```