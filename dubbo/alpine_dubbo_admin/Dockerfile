# Build Alibaba Dubbo RPC Framework
FROM alpine:3.3
MAINTAINER Claude Lee "calee2005@outlook.com"

# Install jdk and others
RUN apk add --update bash patch openjdk8 && rm -rf /var/cache/apk/*

# Setup env
ENV JAVA_HOME /usr/lib/jvm/default-jvm

# Add deps & patch file
ADD alibaba-m2-deps.tar.gz /root/.m2/repository/com/alibaba/
COPY patch.diff /opt/dubbo/patch.diff

WORKDIR /opt/dubbo

# Install maven 3.3.9 & Download Dubbo source code
RUN wget -qO- http://www.us.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar -xzf - -C /opt \
    && mv /opt/apache-maven-3.3.9 /opt/maven \
    && wget -qO- https://github.com/alibaba/dubbo/archive/dubbo-2.5.3.tar.gz | tar -xzf - -C /opt \
    && mv /opt/dubbo-dubbo-2.5.3/* /opt/dubbo/ \
    && patch -p1 < patch.diff \
    && /opt/maven/bin/mvn package -Dmaven.test.skip=true \
    && mkdir /opt/dubbo-dist \
    && mv /opt/dubbo/dubbo/target/dubbo-2.5.3.jar /opt/dubbo-dist/dubbo-2.5.3.jar \
    && mv /opt/dubbo/dubbo-simple/dubbo-monitor-simple/target/dubbo-monitor-simple-2.5.3-assembly.tar.gz /opt/dubbo-dist/dubbo-monitor-simple-2.5.3-assembly.tar.gz \
    && mv /opt/dubbo/dubbo-admin/target/dubbo-admin-2.5.3.war /opt/dubbo-dist/dubbo-admin-2.5.3.war \
    && mv /opt/dubbo/dubbo-demo/dubbo-demo-provider/target/dubbo-demo-provider-2.5.3-assembly.tar.gz /opt/dubbo-dist/dubbo-demo-provider-2.5.3-assembly.tar.gz \
    && rm -rf /opt/maven \
    && rm -rf /opt/dubbo \
    && rm -rf /root/.m2

EXPOSE 8080

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
