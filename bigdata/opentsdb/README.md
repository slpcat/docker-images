安装步骤
hbase创建表
export COMPRESSION=NONE 
export HBASE_HOME=path/to/hbase
./create_table.sh

all-in-one

https://hub.docker.com/r/petergrace/opentsdb-docker/
https://github.com/PeterGrace/opentsdb-docker

docker run -d --restart=always --name opentsdb -p 4242:4242 petergrace/opentsdb-docker


