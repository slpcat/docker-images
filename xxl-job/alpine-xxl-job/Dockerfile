FROM  slpcat/maven:alpine-all AS build
MAINTAINER 若虚 <slpcat@qq.com

RUN apk add git

# install from source
RUN \
    git clone https://github.com/xuxueli/xxl-job.git 

WORKDIR /xxl-job
RUN \
    git checkout v1.9.1 \
    && mvn -Dmaven.test.skip=true clean package install

FROM slpcat/tomcat8:alpine-8.5
MAINTAINER 若虚 <slpcat@qq.com>

COPY --from=build /xxl-job/xxl-job-admin/target/xxl-job-admin-1.9.1.war /xxl-job-admin-1.9.1.war
RUN \
    rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps/ROOT \
    && unzip /xxl-job-admin-1.9.1.war -d /usr/local/tomcat/webapps/ROOT \
    && rm /xxl-job-admin-1.9.1.war

EXPOSE 8080
