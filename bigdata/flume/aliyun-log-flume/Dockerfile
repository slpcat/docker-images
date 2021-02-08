FROM slpcat/maven:3.6-openjdk-11 AS builder
MAINTAINER 若虚 <slpcat@qq.com>

RUN \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz && \
    tar -zxf apache-flume-1.9.0-bin.tar.gz -C /opt/ && \
    sed -i /Xmx20m/d /opt/apache-flume-1.9.0-bin/bin/flume-ng && \
    cd /opt && \
    git clone https://github.com/aliyun/aliyun-log-flume.git && \
    cd aliyun-log-flume/ && \
    mvn clean compile assembly:single -DskipTests && \
    cp target/aliyun-log-flume-1.5.jar /opt/ && \
    cp target/aliyun-log-flume-1.5.jar /opt/apache-flume-1.9.0-bin/lib/

FROM slpcat/openjdk:11-buster
MAINTAINER 若虚 <slpcat@qq.com>

ADD flume-example.conf /var/tmp/flume-example.conf

COPY --from=builder /opt/apache-flume-1.9.0-bin /opt/apache-flume-1.9.0-bin
RUN ln -s /opt/apache-flume-1.9.0-bin /opt/apache-flume

WORKDIR /opt/apache-flume

CMD [ "./bin/flume-ng", "agent", "-c", "./conf", "-f", "flume-example.conf", "-n", "docker", "-Dflume.root.logger=INFO,console" ]

