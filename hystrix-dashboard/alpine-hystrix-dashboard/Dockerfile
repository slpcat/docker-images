FROM slpcat/tomcat8:alpine-8.5
MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-1.8.0}

RUN \
    rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps/ROOT \
    && unzip /pinpoint-web-${PINPOINT_VERSION}.war -d /usr/local/tomcat/webapps/ROOT \
    && rm /pinpoint-web-${PINPOINT_VERSION}.war

COPY start-web.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/start-web.sh"]
