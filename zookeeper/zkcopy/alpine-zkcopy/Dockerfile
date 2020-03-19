FROM  slpcat/maven:alpine AS builder
MAINTAINER 若虚 <slpcat@qq.com>

ADD . /code
WORKDIR /code
RUN mvn install -DskipITs

FROM  slpcat/jdk:alpine
COPY --from=builder /code/target/zkcopy.jar /zkcopy.jar
COPY wrapper .

ENTRYPOINT ["./wrapper"]
