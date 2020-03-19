return [[
> if nginx_user then
user ${{NGINX_USER}};
> end
worker_cpu_affinity auto;
worker_processes ${{NGINX_WORKER_PROCESSES}};
daemon ${{NGINX_DAEMON}};

pid pids/nginx.pid;
error_log ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};

> if nginx_optimizations then
worker_rlimit_nofile ${{WORKER_RLIMIT}};
> end

events {
    use epoll;
> if nginx_optimizations then
    #worker_connections ${{WORKER_CONNECTIONS}};
    worker_connections 50000;
    multi_accept on;
> end
    accept_mutex off;
}

http {
    include 'nginx-kong.conf';
}
]]
