#upstream https://github.com/docker-library/tomcat/tree/master/8.5/

FROM slpcat/tomcat8:alpine-8.5
MAINTAINER 若虚 <slpcat@qq.com>

ENV OTA_EXPORTER_JAEGER_ENDPOINT=localhost:14250 \
    OTA_EXPORTER_JAEGER_SERVICE_NAME=my-tomcat

#install opentelemetry-java-instrumentation
#RUN \
#    wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v0.3.0/opentelemetry-auto-0.3.0.jar \
#    && wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v0.3.0/opentelemetry-auto-exporters-jaeger-0.3.0.jar

COPY catalina.sh /usr/local/tomcat/bin/catalina.sh
COPY *.jar /usr/local/tomcat/lib/

EXPOSE 8080
CMD ["catalina.sh", "run"]
