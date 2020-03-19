# **docker-impala-kudu**
___

### Description
___

This image runs **Cloudera Impala** with Kudu support: it does not depends on HDFS!

The *latest* tag of this image is build with the Cloudera Impala Kudu.

You can pull it with:

    docker pull parrotstream/impala-kudu


You can also find other images based on different Apache Impala releases, using a different tag in the following form:

    docker pull parrotstream/impala-kudu:[impala-kudu-release]-[cdh-release]


Stop with Docker Compose:

    docker-compose -p parrot

Setting the project name to *parrot* with the **-p** option is useful to share the network created with the containers coming from other Parrot docker-compose.yml configurations.


Once started you'll be able to access to the following UIs:

| **Impala Web UIs**           |**URL**                   |
|:----------------------------|:--------------------------|
| *Impala State Store Server* | http://localhost:25010    |
| *Impala Catalog Server*     | http://localhost:25020    |
| *Impala Server Daemon*      | http://localhost:25000    |

### Available tags:

- Impala 2.7.0 ([2.7.0-cdh5.11.1](https://github.com/parrot-stream/docker-impala-kudu/blob/2.7.0-cdh5.11.1/Dockerfile), [latest](https://github.com/parrot-stream/docker-impala-kudu/blob/latest/Dockerfile))
