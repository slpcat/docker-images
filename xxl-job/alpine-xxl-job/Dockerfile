FROM  slpcat/maven:alpine-all AS build
MAINTAINER 若虚 <slpcat@qq.com

ENV PARAMS=""
RUN apk add git

# install from source
RUN \
    git clone https://github.com/xuxueli/xxl-job.git 

WORKDIR /xxl-job
RUN \
    git checkout 2.3.0 \
    && mvn -Dmaven.test.skip=true clean package install

FROM slpcat/oraclejdk:8-bullseye
MAINTAINER 若虚 <slpcat@qq.com>

RUN mkdir -p /xxl-job-admin/config
WORKDIR /xxl-job-admin

COPY --from=build /xxl-job/xxl-job-admin/target/xxl-job-admin-2.3.0.jar /xxl-job-admin/xxl-job-admin.jar

EXPOSE 8080

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/xxl-job-admin/xxl-job-admin.jar","$PARAMS"]
