上游地址
https://github.com/percona/percona-docker
1.单实例 helm/percona
2.多主集群强一致 helm/percona-xtradb-cluster

docker run -d --restart=always --net=host --name percona-server \
-e MYSQL_ROOT_PASSWORD=my_rootpassword -e MYSQL_DATABASE=mydb \
-e MYSQL_USER=myuser -e MYSQL_PASSWORD=mydb_password \
-v /data/mysql-data:/var/lib/mysql \
percona/percona-server:8.0 --character-set-server=utf8 --collation-server=utf8_general_ci
