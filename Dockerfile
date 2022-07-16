FROM alpine
ENV NGINX_VERSION 1.22.0
RUN apk add build-base openssl openssl-dev wget zlib zlib-dev make gd gd-dev geoip geoip-dev perl pcre2 pcre2-dev git
RUN apk add  \
  php81 \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-fpm \
  php81-gd \
  php81-intl \
  php81-mbstring \
  php81-mysqli \
  php81-opcache \
  php81-openssl \
  php81-phar \
  php81-session \
  php81-xml \
  php81-xmlreader \
  php81-zlib \
  supervisor
WORKDIR /usr/src
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar zxvf nginx-${NGINX_VERSION}.tar.gz
RUN git clone https://github.com/google/ngx_brotli
WORKDIR /usr/src/ngx_brotli
RUN git submodule update --init
WORKDIR /usr/src/nginx-${NGINX_VERSION}
RUN ./configure --prefix=/usr/share/nginx --add-module=/usr/src/ngx_brotli --sbin-path=/sbin/nginx --modules-path=/usr/lib/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/dev/stderr --pid-path=/run/nginx.pid --lock-path=/run/nginx.lock --with-select_module --with-poll_module --with-threads  --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --http-log-path=/dev/stdout --http-client-body-temp-path=/tmp/client_body_temp --http-proxy-temp-path=/tmp/proxy_temp --http-fastcgi-temp-path=/tmp/fcgi_temp --http-uwsgi-temp-path=/tmp/uwsgi_temp --http-scgi-temp-path=/tmp/scgi_temp --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module --with-stream_ssl_preread_module
RUN make -j $(nproc)
RUN make install
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY php.ini /etc/php81/conf.d/custom.ini
COPY fpm-pool.conf /etc/php81/php-fpm.d/www.conf
RUN apk del zlib-dev geoip-dev pcre-dev openssl-dev gd-dev build-base
COPY site /usr/share/nginx/html
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
