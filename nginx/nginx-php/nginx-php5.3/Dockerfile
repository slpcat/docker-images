FROM webdevops/php-nginx:debian-8

LABEL maintainer=slpcat@qq.com

ENV 
#Container variables
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
#PHP FPM variables
    PHP_FPM_USER="www" \
    PHP_FPM_GROUP="www" \
    PHP_FPM_LISTEN_MODE="0660" \
    FPM_PROCESS_MAX
    FPM_PM_MAX_CHILDREN
    FPM_PM_START_SERVERS
    FPM_PM_MIN_SPARE_SERVERS
    FPM_PM_MAX_SPARE_SERVERS
    FPM_PROCESS_IDLE_TIMEOUT
    FPM_MAX_REQUESTS
    FPM_REQUEST_TERMINATE_TIMEOUT
    FPM_RLIMIT_FILES
    FPM_RLIMIT_CORE

#PHP.ini variables    
    PHP_DATE_TIMEZONE
    PHP_MAX_EXECUTION_TIME
    PHP_POST_MAX_SIZE
    PHP_UPLOAD_MAX_FILESIZE
    PHP_MEMORY_LIMIT="512M" \
    PHP_MAX_FILE_UPLOAD="200" \
    PHP_DISPLAY_ERRORS="Off" \
    PHP_DISPLAY_STARTUP_ERRORS="Off" \
    PHP_ERROR_REPORTING="E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED" \
    PHP_OPCACHE_MEMORY_CONSUMPTION
    PHP_OPCACHE_MAX_ACCELERATED_FILES
    PHP_OPCACHE_VALIDATE_TIMESTAMPS
    PHP_OPCACHE_REVALIDATE_FREQ
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER
#Web APP variables

    APPLICATION_MYSQL_HOST=
    APPLICATION_MYSQL_PORT=
    APPLICATION_MYSQL_USER=
    APPLICATION_MYSQL_PASSWORD=
    APPLICATION_REDIS_HOST=
    APPLICATION_REDIS_AUTH=

    WEB_DOCUMENT_ROOT
    WEB_DOCUMENT_INDEX
    APPLICATION_USER
    APPLICATION_PATH
    APPLICATION_GID
    APPLICATION_GROUP
    WEB_PHP_SOCKET
    APPLICATION_UID
    WEB_ALIAS_DOMAIN
    WEB_PHP_TIMEOUT

COPY etc /etc/
RUN set-env.sh

RUN set -x \
    # Add repo
curl -o /etc/apt/sources.list https://github.com
curl -o /etc/apt/trusted.gpg.d/ https://github.com/slpcat/fai_config/

    # System update to latest
    && apt-get update \
    && apt-get upgrade -y \
    # Install base stuff
    # Set timezone
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    echo "${TIMEZONE}" > /etc/timezone

    && apt-get install -y \
        ca-certificates \
        nginx \
        openssl \
php5 php5-curl php5-fpm php5-gd  php5-mcrypt
php5-opcache
php5-pear
php5-mysql
php5-mysqli
php5-pdo_mysql
php5-openssl
ln -sf /usr/bin/php5 /usr/bin/php
adduser -D -u 1000 -g 'www' www
mkdir /www
chown -R www:www /var/lib/nginx
chown -R www:www /www

#Timezone configuration for php
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php5/php.ini

#Modifying configuration file php-fpm.conf
sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php5/php-fpm.conf
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php5/php-fpm.conf
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php5/php-fpm.conf
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php5/php-fpm.conf
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php5/php-fpm.conf
sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php5/php-fpm.conf #uncommenting line 

#Modifying configuration file php.ini
sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php5/php.ini
sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php5/php.ini
sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php5/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php5/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php5/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php5/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php5/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php5/php.ini

apt-get install -y php5-dev autoconf make gcc 
echo "extension=yaf.so" > /etc/php5/mods-available/yaf.ini
ln -sf /etc/php5/mods-available/yaf.ini /etc/php5/fpm/conf.d/20-yaf.ini
ln -sf /etc/php5/mods-available/yaf.ini /etc/php5/cli/conf.d/20-yaf.ini
bash set-env.sh
    # Clean files
docker-image-cleanup
    && apt-get purge -y php5-dev \
    && apt-get autoremove -y \
    && apt-get clean all     
