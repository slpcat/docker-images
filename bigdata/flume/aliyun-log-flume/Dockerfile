FROM probablyfine/flume

ADD flume-example.conf /var/tmp/flume-example.conf
RUN \
    wget https://github.com/aliyun/aliyun-log-flume/releases/download/1.3/aliyun-log-flume-1.3.jar

EXPOSE 44444
ENTRYPOINT [ "flume-ng", "agent",
  "-c", "/opt/flume/conf", "-f", "/var/tmp/flume-example.conf", "-n", "docker",
  "-Dflume.root.logger=INFO,console" ]

wget http://apache.tt.co.kr/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
 
[hadoop@hadoop004 software]$ tar -zxf apache-flume-1.9.0-bin.tar.gz -C ../app/
 
[hadoop@hadoop004 software]$ git clone https://github.com/aliyun/aliyun-log-flume.git
 
[hadoop@hadoop004 software]$ cd aliyun-log-flume/
 
[hadoop@hadoop004 aliyun-log-flume]$ mvn clean compile assembly:single -DskipTests
[hadoop@hadoop004 aliyun-log-flume]$ cd target/
 
[hadoop@hadoop004 target]$ ls
aliyun-log-flume-1.1.jar  archive-tmp  classes  generated-sources  maven-status
 
[hadoop@hadoop004 target]$ cp aliyun-log-flume-1.1.jar /data/aaron/app/apache-flume-1.6.0-cdh5.7.0-bin/lib/


