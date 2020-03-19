[![Docker Automated build](https://img.shields.io/docker/automated/bigtruedata/scala.svg?style=plastic)](https://hub.docker.com/r/bigtruedata/scala/)
[![Docker Build Status](https://img.shields.io/docker/build/bigtruedata/scala.svg?style=plastic)](https://hub.docker.com/r/bigtruedata/scala/builds/)
![Docker Pulls](https://img.shields.io/docker/pulls/bigtruedata/scala.svg?style=plastic)
![Docker Stars](https://img.shields.io/docker/stars/bigtruedata/scala.svg?style=plastic)

[![Travis Status](https://img.shields.io/travis/bigtruedata/docker-scala.svg?style=plastic)](https://travis-ci.org/bigtruedata/docker-scala/builds)
[![License](https://img.shields.io/github/license/bigtruedata/docker-scala.svg?style=plastic)](https://raw.githubusercontent.com/bigtruedata/docker-scala/blob/master/LICENSE)

# [Scala Docker Image](https://hub.docker.com/r/bigtruedata/scala/)

## Supported tags and respective `Dockerfile` links
- [`2.12.4`,`2.12`,`latest`(2.12.4/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.4/Dockerfile)
- [`2.12.4-alpine`,`2.12-alpine`,`alpine`(2.12.4/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.4/alpine/Dockerfile)
- [`2.11.12`,`2.11`(2.11.12/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.12/Dockerfile)
- [`2.11.12-alpine`,`2.11-alpine`(2.11.12/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.12/alpine/Dockerfile)
- [`2.10.7`,`2.10`(2.10.7/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.7/Dockerfile)
- [`2.10.7-alpine`,`2.10-alpine`(2.10.7/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.7/alpine/Dockerfile)

See also the [previous versions](#previous-versions) of the Scala Docker image.

---

[![logo](https://raw.githubusercontent.com/bigtruedata/docker-scala/master/logo.png)](http://scala-lang.org)

Scala is an acronym for “Scalable Language”. This means that Scala grows with you. You can play with it by typing one-line expressions and observing the results. But you can also rely on it for large mission critical systems.

Check the [Scala documentation](http://docs.scala-lang.org/) to get more information about the Scala programming language.

## Quick Start
This image provides an installation of the Scala environment. It consists on the Scala REPL (*scala*), the Scala compiler (*scalac*), the Scala class file decoder (*scalap*), and the Scala documentation generation tool (*scaladoc*). If not specified any command on `bigtruedata/scala` image execution (as specified in the following example), the Scala REPL will be launched.

```sh
docker run --rm --tty --interactive bigtruedata/scala
```

This image can also be use in a standalone fashion the same way as if the environment was directly installed in the local machine. You just need to provide the path to the directory contained the source files to work with and the command to be executed. To avoid writting tons of commands, the following aliases may be handy:

```sh
alias scala='docker run --rm --tty --interactive --volume $PWD:/app bigtruedata/scala'
alias scalac='docker run --rm --tty --interactive --volume $PWD:/app bigtruedata/scala scalac'
alias scalap='docker run --rm --tty --interactive --volume $PWD:/app bigtruedata/scala scalap'
alias scaladoc='docker run --rm --tty --interactive --volume $PWD:/app bigtruedata/scala scaladoc'
```

## Image Variants
This image is based on the [`openjdk:8`](https://hub.docker.com/_/openjdk/) image to provide the Java installation required by the Scala environment. This repository contains a default image for Scala and an alpine-based image. The standard image is referenced using the Scala version as image tag (like `bigtruedata/scala:2.11.7`). The alpine-based image is used where small Docker images are required. They are referenced using the suffix `-alpine` (like `bigtruedata/scala:2.11.7-alpine`).

The different versions of this image correspond tho the released versions of Scala that can be downloaded from the [Scala downloads](http://scala-lang.org/download/all.html) website. New Scala versions are generated as long as they are released and become available on download website.

### Previous Versions
- [`2.12.3`(2.12.3/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.3/Dockerfile)
- [`2.12.3-alpine`(2.12.3/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.3/alpine/Dockerfile)
- [`2.12.2`(2.12.2/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.2/Dockerfile)
- [`2.12.2-alpine`(2.12.2/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.2/alpine/Dockerfile)
- [`2.12.1`(2.12.1/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.1/Dockerfile)
- [`2.12.1-alpine`(2.12.1/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.1/alpine/Dockerfile)
- [`2.12.0`(2.12.0/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.0/Dockerfile)
- [`2.12.0-alpine`(2.12.0/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.12.0/alpine/Dockerfile)
- [`2.11.11`(2.11.11/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.11/Dockerfile)
- [`2.11.11-alpine`(2.11.11/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.11/alpine/Dockerfile)
- [`2.11.10`(2.11.10/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.10/Dockerfile)
- [`2.11.10-alpine`(2.11.10/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.10/alpine/Dockerfile)
- [`2.11.9`(2.11.9/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.9/Dockerfile)
- [`2.11.9-alpine`(2.11.9/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.9/alpine/Dockerfile)
- [`2.11.8`(2.11.8/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.8/Dockerfile)
- [`2.11.8-alpine`(2.11.8/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.8/alpine/Dockerfile)
- [`2.11.7`(2.11.7/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.7/Dockerfile)
- [`2.11.7-alpine`(2.11.7/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.7/alpine/Dockerfile)
- [`2.11.6`(2.11.6/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.6/Dockerfile)
- [`2.11.6-alpine`(2.11.6/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.6/alpine/Dockerfile)
- [`2.11.5`(2.11.5/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.5/Dockerfile)
- [`2.11.5-alpine`(2.11.5/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.5/alpine/Dockerfile)
- [`2.11.4`(2.11.4/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.4/Dockerfile)
- [`2.11.4-alpine`(2.11.4/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.4/alpine/Dockerfile)
- [`2.11.3`(2.11.3/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.3/Dockerfile)
- [`2.11.3-alpine`(2.11.3/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.3/alpine/Dockerfile)
- [`2.11.2`(2.11.2/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.2/Dockerfile)
- [`2.11.2-alpine`(2.11.2/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.2/alpine/Dockerfile)
- [`2.11.1`(2.11.1/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.1/Dockerfile)
- [`2.11.1-alpine`(2.11.1/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.1/alpine/Dockerfile)
- [`2.11.0`(2.11.0/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.0/Dockerfile)
- [`2.11.0-alpine`(2.11.0/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.11.0/alpine/Dockerfile)
- [`2.10.6`(2.10.6/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.6/Dockerfile)
- [`2.10.6-alpine`(2.10.6/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.6/alpine/Dockerfile)
- [`2.10.5`(2.10.5/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.5/Dockerfile)
- [`2.10.5-alpine`(2.10.5/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.5/alpine/Dockerfile)
- [`2.10.4`(2.10.4/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.4/Dockerfile)
- [`2.10.4-alpine`(2.10.4/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.4/alpine/Dockerfile)
- [`2.10.3`(2.10.3/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.3/Dockerfile)
- [`2.10.3-alpine`(2.10.3/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.3/alpine/Dockerfile)
- [`2.10.2`(2.10.2/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.2/Dockerfile)
- [`2.10.2-alpine`(2.10.2/alpine/Dockerfile)](https://github.com/bigtruedata/docker-scala/blob/master/2.10.2/alpine/Dockerfile)

## License

### The MIT License (MIT)

Copyright © `2017` `BigTrueData`

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
“Software”), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
