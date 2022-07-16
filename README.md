
# Nginx+PHP+Docker

## How to use it
```bash
$ docker build -t nginx-php:latest .
```
```bash
$ docker run -p 8080:80 -v /usr/share/nginx/html:/www nginx-php
```
