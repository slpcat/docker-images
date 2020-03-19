#upstream: https://raw.githubusercontent.com/wupeng1988/docker-memcacheq/master/Dockerfile
FROM slpcat/centos:7
MAINTAINER slpcat@qq.com

RUN yum update -y && yum upgrade -y && yum install -y gcc wget make \
	&& mkdir /source && cd /source \
	&& mkdir -p /home/mcq \
	&& wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz \
	&& tar zxf libevent-2.0.22-stable.tar.gz -C /home/mcq \
	&& cd /home/mcq/libevent-2.0.22-stable \
	&& ./configure --prefix=/usr/local/libevent \
	&& make && make install \
	&& wget http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz \
	&& tar xzf db-6.2.23.tar.gz -C /home/mcq \
	&& cd /home/mcq/db-6.2.23/build_unix \
	&& ../dist/configure \
	&& make && make install \
	&& echo /usr/local/lib >> /etc/ld.so.conf \
	&& echo  /usr/local/BerkeleyDB.6.2/lib >> /etc/ld.so.conf \
	&& ldconfig \
	&& cd /source \
	&& wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.1.tar.gz \
	&& tar zxf memcacheq-0.2.1.tar.gz -C /home/mcq \
	&& cd /home/mcq/memcacheq-0.2.1 \
	&& ./configure --enable-threads --with-bdb=/usr/local/BerkeleyDB.6.2/ --with-libevent=/usr/local/libevent \ 
	&& make && make install \
	&& mkdir /home/mcq-data \
	&& chown root:root /home/mcq-data/ \
	&& ln -s /usr/local/libevent/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5 \
	&& echo /usr/local/bin/memcacheq -uroot -H /home/mcq-data > /home/mcq/run.sh \
	&& chmod a+x /home/mcq/run.sh \
	&& rm -rf /source 

EXPOSE 22201

VOLUME ["/home/mcq-data"]

#ENTRYPOINT ["/usr/local/bin/memcacheq"]
ENTRYPOINT /usr/local/bin/memcacheq -uroot -H /home/mcq-data
#CMD ["-uroot -H /home/mcq-data"]
