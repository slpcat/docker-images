# Generated automatically by update.sh
# Do no edit this file

FROM openjdk:8-alpine

# Patch to generate images in Wercker's pipelines.
COPY env /usr/local/bin/env

# The bash shell is required by Scala utilities
RUN apk add --no-cache bash

# Install build dependencies
RUN apk add --no-cache --virtual=.dependencies tar wget

RUN wget -O- "http://downloads.lightbend.com/scala/2.10.2/scala-2.10.2.tgz" \
    | tar xzf - -C /usr/local --strip-components=1

# Remove build dependencies
RUN apk del --no-cache .dependencies

VOLUME /app
WORKDIR /app

CMD ["scala"]
