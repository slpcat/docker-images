# Prometheus ZooKeeper Exporter [![Build Status](https://travis-ci.org/lucianjon/zk-exporter.svg?branch=master)](https://travis-ci.org/lucianjon/zk-exporter)

The exporter peridically scrapes Zookeeper metrics via four letter word commands, see https://zookeeper.apache.org/doc/trunk/zookeeperAdmin.html#The+Four+Letter+Words. Currently exposes metrics from the "mntr" and "ruok" (requires ZooKeeper 3.4.0 or above)

These are parsed into prometheus metrics and served on an endpoint at `/metrics`

Still a WIP

## Installation

Currently requires go for installation. Binaries and a docker image will be coming.

To install the latest version run:

```
go get -u github.com/lucianjon/zk-exporter
```

Note: you should have $GOPATH/bin added to your $PATH

## Usage

Once installed run: 

```
zk-exporter -port <port> -servers <zookeeper servers> -pollinterval <how often to poll>
```
The ZooKeeper servers are a string in the `host:port,host2:port2` format.
The pollinterval is a go time.Duration value, eg: `30s`

## Getting Started

* By default metrics are exposed on `0.0.0.0:9120/metrics`
