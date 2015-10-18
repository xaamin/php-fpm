## PHP dockerfile
This repository contains **Dockerfile** of PHP5-FPM Docker's [automated build](https://hub.docker.com/r/xaamin/php-fpm)

### Base docker image
* [xaamin/php](https://registry.hub.docker.com/r/xaamin/php)

### Installation
* Install [Docker](https://www.docker.com)
* Pull from [Docker Hub](https://hub.docker.com/r/xaamin/php-fpm) `docker pull xaamin/php-fpm`

### Manual build
* Build an image from Dockerfile `docker build -t xaamin/php-fpm https://github.com/xaamin/ubuntu-php-fpm.git`

### Volumes
You must provide a volume mounted on /data containing all files to serve

### Usage
```
	docker run --rm -it -v /path/with/php/files:/data xaamin/php-fpm
```