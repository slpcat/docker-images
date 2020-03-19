FROM amancevice/superset
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

USER root

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list 

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \ 
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

COPY pip.conf /etc/pip.conf
#Database dependencies
RUN \
    pip install --upgrade pip \
    && pip install psycopg2-binary \
    && pip install "PyAthenaJDBC>1.0.9" \
    && pip install "PyAthena>1.2.0" \
    && pip install sqlalchemy-redshift \
    #&& pip install sqlalchemy-drill \
    && pip install pydruid \
    && pip install pyhive \
    && pip install impyla \
    && pip install kylinpy \
    && pip install pinotdb \
    && pip install pyhive \
    && pip install pybigquery \
    ##&& pip install sqlalchemy-clickhouse \
    && pip install clickhouse-sqlalchemy \
    && pip install elasticsearch-dbapi \
    #&& pip install sqlalchemy-exasol \
    && pip install gsheetsdb \
    && pip install ibm_db_sa \
    && pip install mysqlclient \
    && pip install cx_Oracle \
    && pip install psycopg2 \
    && pip install snowflake-sqlalchemy \
    && pip install pymssql \
    && pip install sqlalchemy-teradata \
    && pip install sqlalchemy-vertica-python \
    && pip install hdbcli sqlalchemy-hana


USER superset
