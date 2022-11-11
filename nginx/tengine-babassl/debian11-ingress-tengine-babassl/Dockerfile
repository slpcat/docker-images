FROM slpcat/debian:bullseye AS builder

COPY . /

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && /build.sh

# Use a multi-stage build
FROM slpcat/debian:bullseye

ENV PATH=$PATH:/usr/local/luajit/bin:/usr/local/nginx/sbin:/usr/local/nginx/bin

ENV LUA_PATH="/usr/local/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/?.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/?/?.so;/usr/local/lib/lua/?.so;;"

COPY --from=builder /usr/local /usr/local
COPY --from=builder /opt /opt
COPY --from=builder /etc/nginx /etc/nginx

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y libxslt1.1 libxml2 libjemalloc2 libgd3 libgeoip1 libmaxminddb0 \
    && ldconfig \
    && ln -s /usr/local/nginx/sbin/nginx /sbin/nginx \
    && bash -eu -c ' \
    writeDirs=( \
      /var/log/nginx \
      /var/lib/nginx/body \
      /var/lib/nginx/fastcgi \
      /var/lib/nginx/proxy \
      /var/lib/nginx/scgi \
      /var/lib/nginx/uwsgi \
      /var/log/audit \
    ); \
    for dir in "${writeDirs[@]}"; do \
      mkdir -p ${dir}; \
      chown -R www-data.www-data ${dir}; \
    done'

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
