# Generated automatically by update.sh
# Do no edit this file

FROM openjdk:8

RUN wget -O- "http://downloads.lightbend.com/scala/2.10.7/scala-2.10.7.tgz" \
    | tar xzf - -C /usr/local --strip-components=1

VOLUME /app
WORKDIR /app

CMD ["scala"]
