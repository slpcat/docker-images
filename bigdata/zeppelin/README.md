[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/big-data-europe/Lobby)

# Docker Zeppelin

This repository contains [Apache Zeppelin](https://zeppelin.apache.org/) docker image, which is tuned to work with BDE clusters.

# Example Usage

For example usage see [docker-compose.yml](./docker-compose.yml) and [SANSA-Notebooks repository](https://github.com/SANSA-Stack/SANSA-Notebooks).

# Dev
Start Hadoop/Spark cluster with Zeppelin notebook:
```
make up
```
Tear down Hadoop/Spark cluster with Zeppelin notebook:
```
make down
```
Bash into Zeppelin container:
```
make bash
```
Build and run Zeppelin separately:
```
make up
docker stop dockerzeppelin_zeppelin_1 && docker rm dockerzeppelin_zeppelin_1
make run
```
Build Zeppelin:
```
make build
```
For more details see the Makefile.
