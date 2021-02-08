FROM slpcat/openjdk:11-buster AS builder
FROM probablyfine/flume

RUN \
    wget https://github.com/aliyun/aliyun-log-flume/releases/download/1.3/aliyun-log-flume-1.3.jar

wget http://apache.tt.co.kr/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
 
tar -zxf apache-flume-1.9.0-bin.tar.gz -C ../app/
 
git clone https://github.com/aliyun/aliyun-log-flume.git
 
cd aliyun-log-flume/
 
mvn clean compile assembly:single -DskipTests
cd target/
 
 ls
aliyun-log-flume-1.1.jar  archive-tmp  classes  generated-sources  maven-status
 

FROM slpcat/openjdk:11-buster

ADD flume-example.conf /var/tmp/flume-example.conf

COPY --from builder /app/target/aliyun-log-flume-1.1.jar /data/aaron/app/apache-flume-1.6.0-cdh5.7.0-bin/lib/
EXPOSE 44444
ENTRYPOINT [ "flume-ng", "agent",
  "-c", "/opt/flume/conf", "-f", "/var/tmp/flume-example.conf", "-n", "docker",
  "-Dflume.root.logger=INFO,console" ]

