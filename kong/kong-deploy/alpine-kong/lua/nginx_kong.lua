return [[
charset UTF-8;

> if anonymous_reports then
${{SYSLOG_REPORTS}}
> end

error_log ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};

> if nginx_optimizations then
>-- send_timeout 60s;          # default value
>-- keepalive_timeout 75s;     # default value
>-- client_body_timeout 60s;   # default value
>-- client_header_timeout 60s; # default value
>-- tcp_nopush on;             # disabled until benchmarked
>-- proxy_buffer_size 128k;    # disabled until benchmarked
>-- proxy_buffers 4 256k;      # disabled until benchmarked
>-- proxy_busy_buffers_size 256k; # disabled until benchmarked
>-- reset_timedout_connection on; # disabled until benchmarked
> end

  #重定向使用域名(Host头)
  server_name_in_redirect on;
  server_names_hash_bucket_size 256;
  connection_pool_size 4096;
  disable_symlinks off;
  etag on;
  ignore_invalid_headers on;
  merge_slashes on;
  keepalive_disable msie6;
  client_header_buffer_size 4k;
  large_client_header_buffers 4 32k;

  open_file_cache max=1000 inactive=20s;
  open_file_cache_valid 30s;
  open_file_cache_min_uses 1;
  open_file_cache_errors on;
  read_ahead 128k;
  sendfile        on;
  sendfile_max_chunk 512k;
# directio 4m;
  tcp_nodelay   on;
  tcp_nopush    on;
  types_hash_max_size 2048;
  request_pool_size 4k;
  keepalive_timeout  60;
  keepalive_requests 5000;
  lingering_close on;
  recursive_error_pages      on;
  output_buffers 8 64k;
  postpone_output 1460;

  proxy_http_version 1.1;
  #避免一次将大文件加入缓存
  proxy_set_header Range $http_range;
  proxy_set_header If-Range $http_if_range;
  proxy_no_cache  $http_range $http_if_range;
  #proxy_buffering off;
  proxy_connect_timeout 600;
  proxy_send_timeout 600;
  proxy_read_timeout 600;
  proxy_temp_file_write_size 256k;
  proxy_max_temp_file_size 64m;
  #屏蔽后端错误信息
  proxy_intercept_errors  on;
  proxy_ignore_client_abort on;
  #proxy_temp_path  /var/lib/nginx/tmp/proxy;
  proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;

  gzip  on;
  gzip_disable "msie6";
  #gzip_static on;
  gzip_proxied any;
  gzip_min_length  4k;
  gzip_buffers     32 8k;
  gzip_http_version 1.1;
  gzip_comp_level 2;
  gzip_types       text/plain text/css text/xml text/javascript application/json application/x-javascript application/javascript application/xml application/xml+rss font/ttf font/otf image/svg+xml;
  gzip_vary on;


client_max_body_size ${{CLIENT_MAX_BODY_SIZE}};
proxy_ssl_server_name on;
underscores_in_headers on;

lua_package_path '${{LUA_PACKAGE_PATH}};;';
lua_package_cpath '${{LUA_PACKAGE_CPATH}};;';
lua_socket_pool_size ${{LUA_SOCKET_POOL_SIZE}};
lua_max_running_timers 4096;
lua_max_pending_timers 16384;
lua_shared_dict kong                5m;
lua_shared_dict kong_db_cache       ${{MEM_CACHE_SIZE}};
lua_shared_dict kong_db_cache_miss 12m;
lua_shared_dict kong_locks          8m;
lua_shared_dict kong_process_events 5m;
lua_shared_dict kong_cluster_events 5m;
lua_shared_dict kong_healthchecks   5m;
lua_shared_dict kong_rate_limiting_counters 12m;
> if database == "cassandra" then
lua_shared_dict kong_cassandra      5m;
> end
lua_socket_log_errors off;
> if lua_ssl_trusted_certificate then
lua_ssl_trusted_certificate '${{LUA_SSL_TRUSTED_CERTIFICATE}}';
lua_ssl_verify_depth ${{LUA_SSL_VERIFY_DEPTH}};
> end

# injected nginx_http_* directives
> for _, el in ipairs(nginx_http_directives)  do
$(el.name) $(el.value);
> end

init_by_lua_block {
    Kong = require 'kong'
    Kong.init()
}

init_worker_by_lua_block {
    Kong.init_worker()
}


> if #proxy_listeners > 0 then
upstream kong_upstream {
    server 0.0.0.1;
    balancer_by_lua_block {
        Kong.balancer()
    }
    keepalive ${{UPSTREAM_KEEPALIVE}};
}

server {
    server_name kong;
> for i = 1, #proxy_listeners do
    listen $(proxy_listeners[i].listener) backlog=16384 reuseport fastopen=4096 bind so_keepalive=on;
> end
    error_page 400 404 408 411 412 413 414 417 494 /kong_error_handler;
    error_page 500 502 503 504 /kong_error_handler;

    access_log ${{PROXY_ACCESS_LOG}};
    error_log ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};

    client_body_buffer_size ${{CLIENT_BODY_BUFFER_SIZE}};

> if proxy_ssl_enabled then
    ssl_certificate ${{SSL_CERT}};
    ssl_certificate_key ${{SSL_CERT_KEY}};
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_certificate_by_lua_block {
        Kong.ssl_certificate()
    }

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ${{SSL_CIPHERS}};
> end

> if client_ssl then
    proxy_ssl_certificate ${{CLIENT_SSL_CERT}};
    proxy_ssl_certificate_key ${{CLIENT_SSL_CERT_KEY}};
> end

    real_ip_header     ${{REAL_IP_HEADER}};
    real_ip_recursive  ${{REAL_IP_RECURSIVE}};
> for i = 1, #trusted_ips do
    set_real_ip_from   $(trusted_ips[i]);
> end

    # injected nginx_proxy_* directives
> for _, el in ipairs(nginx_proxy_directives)  do
    $(el.name) $(el.value);
> end

    location / {
        default_type                     '';

        set $ctx_ref                     '';
        set $upstream_host               '';
        set $upstream_upgrade            '';
        set $upstream_connection         '';
        set $upstream_scheme             '';
        set $upstream_uri                '';
        set $upstream_x_forwarded_for    '';
        set $upstream_x_forwarded_proto  '';
        set $upstream_x_forwarded_host   '';
        set $upstream_x_forwarded_port   '';

        rewrite_by_lua_block {
            Kong.rewrite()
        }

        access_by_lua_block {
            Kong.access()
        }

        proxy_http_version 1.1;
        proxy_set_header   Host              $upstream_host;
        proxy_set_header   Upgrade           $upstream_upgrade;
        proxy_set_header   Connection        $upstream_connection;
        proxy_set_header   X-Forwarded-For   $upstream_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $upstream_x_forwarded_proto;
        proxy_set_header   X-Forwarded-Host  $upstream_x_forwarded_host;
        proxy_set_header   X-Forwarded-Port  $upstream_x_forwarded_port;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_pass_header  Server;
        proxy_pass_header  Date;
        proxy_ssl_name     $upstream_host;
        proxy_pass         $upstream_scheme://kong_upstream$upstream_uri;

        header_filter_by_lua_block {
            Kong.header_filter()
        }

        body_filter_by_lua_block {
            Kong.body_filter()
        }

        log_by_lua_block {
            Kong.log()
        }
    }

    location = /kong_error_handler {
        internal;
        uninitialized_variable_warn off;

        content_by_lua_block {
            Kong.handle_error()
        }

        header_filter_by_lua_block {
            Kong.header_filter()
        }

        body_filter_by_lua_block {
            Kong.body_filter()
        }

        log_by_lua_block {
            Kong.log()
        }
    }
}
> end

> if #admin_listeners > 0 then
server {
    server_name kong_admin;
> for i = 1, #admin_listeners do
    listen $(admin_listeners[i].listener);
> end

    access_log ${{ADMIN_ACCESS_LOG}};
    error_log ${{ADMIN_ERROR_LOG}} ${{LOG_LEVEL}};

    client_max_body_size 10m;
    client_body_buffer_size 10m;

> if admin_ssl_enabled then
    ssl_certificate ${{ADMIN_SSL_CERT}};
    ssl_certificate_key ${{ADMIN_SSL_CERT_KEY}};
    ssl_protocols TLSv1.1 TLSv1.2;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ${{SSL_CIPHERS}};
> end

    # injected nginx_admin_* directives
> for _, el in ipairs(nginx_admin_directives)  do
    $(el.name) $(el.value);
> end

    location / {
        default_type application/json;
        content_by_lua_block {
            Kong.serve_admin_api()
        }
    }

    location /nginx_status {
        internal;
        access_log off;
        stub_status;
    }

    location /robots.txt {
        return 200 'User-agent: *\nDisallow: /';
    }
}
> end
]]
