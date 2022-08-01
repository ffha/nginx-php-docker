FROM debian:stable-slim
WORKDIR /usr/src
RUN apt-get update && apt-get install -y wget tini curl
RUN wget -c http://mirrors.linuxeye.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && ./oneinstack/install.sh --nginx_option 2 --php_option 11 --phpcache_option 1 --php_extensions imagick,fileinfo,imap,ldap,memcache
COPY start.sh /start.sh
RUN chmod 755 /start.sh
CMD /start.sh
RUN rm -rf /usr/src/*
ENTRYPOINT ["/usr/bin/tini", "--"]
