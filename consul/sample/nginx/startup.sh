consul-template \
-consul-addr 192.168.1.79:8500 \
-template "./nginx.ctmpl:/etc/nginx/conf.d/default2.conf:/usr/sbin/nginx -s reload" \
-log-level=info
