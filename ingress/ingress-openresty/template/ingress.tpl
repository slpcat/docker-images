## Generic OpenResty config file
## I am a generic file, you might want to change me to your needs!
{{- if not .AllowHTTP }}
server {
    server_name {{ .Domain }} www.{{ .Domain }};

    listen 80;
    listen [::]:80;

    location / {
        return 301 https://$host$request_uri;
    }
}
{{- end }}

server {
    server_name {{ .Domain }} www.{{ .Domain }};

    {{- if .AllowHTTP }}
    listen 80;
    listen [::]:80;
    {{- end }}
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    resolver 1.1.1.1;
    resolver_timeout 20s;

    # Add custom OpenResty TLS handling here!

    ssl_stapling on;
    ssl_stapling_verify on;
    #ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ssl_certificate /etc/ssl/resty-auto-ssl-fallback.crt;
    ssl_certificate_key /etc/ssl/resty-auto-ssl-fallback.key;

    access_log none;
    error_log /error;

    # disable any limits to avoid HTTP 413 for large image uploads
    client_max_body_size 0;

    # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
    chunked_transfer_encoding on;

    {{range .Values}}
    location {{ .Path }} {
        access_log off;

        proxy_pass http://{{ .Host }}:{{ .Port }};
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_connect_timeout 20s;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_buffering off;
        send_timeout           300;

        add_header "X-Upstream-Addr" "$upstream_addr" always;

        add_header "Strict-Transport-Security" "max-age=15768000" always;

        # CORS
        add_header "Access-Control-Allow-Origin" "*" always;
        add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, PUT, DELETE" always;
        add_header "Access-Control-Allow-Credentials" "true" always;
        add_header "Access-Control-Allow-Headers" "DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization" always;
        add_header "Access-Control-Max-Age" "1728000" always;
        if ($request_method = 'OPTIONS') {
            add_header "Access-Control-Allow-Origin" "*" always;
            add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, PUT, DELETE" always;
            add_header "Access-Control-Allow-Credentials" "true" always;
            add_header "Access-Control-Allow-Headers" "DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization" always;
            add_header "Access-Control-Max-Age" "1728000" always;
            add_header "Content-Type" "text/plain charset=UTF-8" always;
            add_header "Content-Length" "0" always;
            return 204;
        }
    }
    {{end}}
    
}
