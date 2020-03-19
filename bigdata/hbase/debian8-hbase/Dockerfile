FROM java:7
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN echo 'deb http://mirrors.aliyun.com/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

ENV HBASE_VERSION 1.2.6.1
ENV HBASE_INSTALL_DIR /opt/hbase

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

RUN mkdir -p ${HBASE_INSTALL_DIR} && \
    curl -L http://mirrors.aliyun.com/apache/hbase//${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar -xz --strip=1 -C ${HBASE_INSTALL_DIR}

RUN sed -i "s/httpredir.debian.org/mirrors.163.com/g" /etc/apt/sources.list
#RUN \
#    rm ${HBASE_INSTALL_DIR}/lib/zookeeper-3.4.6.jar

#COPY zookeeper-3.4.10.jar ${HBASE_INSTALL_DIR}/lib/zookeeper-3.4.10.jar
# build LZO
WORKDIR /tmp
#RUN apt-get update && \
#    apt-get install -y build-essential maven lzop liblzo2-2 && \
#    wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz && \
#    tar zxvf lzo-2.09.tar.gz && \
#    cd lzo-2.09 && \
#    ./configure --enable-shared --prefix /usr/local/lzo-2.09 && \
#    make && make install && \
#    cd .. && git clone https://github.com/twitter/hadoop-lzo.git && cd hadoop-lzo && \
#    git checkout release-0.4.20 && \
#    C_INCLUDE_PATH=/usr/local/lzo-2.09/include LIBRARY_PATH=/usr/local/lzo-2.09/lib mvn clean package && \
#    apt-get remove -y build-essential maven && \
#    apt-get clean autoclean && \
#    apt-get autoremove --yes && \
#    rm -rf /var/lib/{apt,dpkg,cache.log}/ && \
#    cd target/native/Linux-amd64-64 && \
#    tar -cBf - -C lib . | tar -xBvf - -C /tmp && \
#    mkdir -p ${HBASE_INSTALL_DIR}/lib/native && \
#    cp /tmp/libgplcompression* ${HBASE_INSTALL_DIR}/lib/native/ && \
#    cd /tmp/hadoop-lzo && cp target/hadoop-lzo-0.4.20.jar ${HBASE_INSTALL_DIR}/lib/ && \
#    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lzo-2.09/lib" >> ${HBASE_INSTALL_DIR}/conf/hbase-env.sh && \
#    rm -rf /tmp/lzo-2.09* hadoop-lzo lib libgplcompression*

ADD hbase-site.xml /opt/hbase/conf/hbase-site.xml
#ADD core-site.xml /opt/hbase/conf/core-site.xml
#ADD hdfs-site.xml /opt/hbase/conf/hdfs-site.xml
ADD start-k8s-hbase.sh /opt/hbase/bin/start-k8s-hbase.sh
RUN chmod +x /opt/hbase/bin/start-k8s-hbase.sh

WORKDIR ${HBASE_INSTALL_DIR}
RUN echo "export HBASE_JMX_BASE=\"-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false\"" >> conf/hbase-env.sh && \
    echo "export HBASE_MASTER_OPTS=\"\$HBASE_MASTER_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10101\"" >> conf/hbase-env.sh && \
    echo "export HBASE_REGIONSERVER_OPTS=\"\$HBASE_REGIONSERVER_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10102\"" >> conf/hbase-env.sh && \
    echo "export HBASE_THRIFT_OPTS=\"\$HBASE_THRIFT_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10103\"" >> conf/hbase-env.sh && \
    echo "export HBASE_ZOOKEEPER_OPTS=\"\$HBASE_ZOOKEEPER_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10104\"" >> conf/hbase-env.sh && \
    echo "export HBASE_REST_OPTS=\"\$HBASE_REST_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10105\"" >> conf/hbase-env.sh

ENV PATH=$PATH:/opt/hbase/bin

CMD /opt/hbase/bin/start-k8s-hbase.sh
