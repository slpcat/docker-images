A Prometheus exporter for Zookeeper 3.4+. It send the mntr command to a Zookeeper node and converts the output to Prometheus format.

Building from source
go get -u https://github.com/jiankunking/zookeeper_exporter and then make build.

Limitations
Due to the type of data exposed by Zookeeper's mntr command, it currently resets Zookeeper's internal statistics every time it is scraped. This makes it unsuitable for having multiple parallel scrapers.

修改信息
在原来的基础上添加了 支持ansible部署（支持指定exporter上报端口、监听zk的ip port） 启动参数 需要监控zk的地址:zk的端口 上报的端口 比如10.135.22.22:2181 :9123 目前不支持一个exporter监听多个zk 如果不指定启动参数 默认监听localhost:2181，默认上报端口9141

