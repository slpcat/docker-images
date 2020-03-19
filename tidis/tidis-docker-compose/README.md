## Run Tidis in one command using docker-compose

1. Clone tidis-docker-compose repo

```
~ git clone https://github.com/yongman/tidis-docker-compose.git
```

2. Run

```
~ cd tidis-docker-compose/

~ docker-compose up -d
Creating network "docker_default" with the default driver
Creating docker_pd_1 ... done
Creating docker_tikv_1 ... done
Creating docker_tidis_1 ... done
```

3. Stop and delete

```
~ docker-compose down
```

**This compose file is just use one pd and one tikv instance for test, not for production**

4. Run for dev

Replace `YOUR_CODE_PATH` to tidis source code directory path

```
~ cd tidis-docker-compose
~ TIDIS_DIR_SRC=YOUR_CODE_PATH docker-compose -f docker-compose-dev.yml up -d
Creating network "tidis-docker-compose_default" with the default driver
Creating tidis-docker-compose_pd_1 ... done
Creating tidis-docker-compose_tikv_1 ... done
Creating tidis-docker-compose_tidis_1 ... done
~ docker exec -it tidis-docker-compose_tidis_1 /bin/bash
root@48d5a178290c:/go# cd /go/src/github.com/yongman/tidis/
root@48d5a178290c:/go/src/github.com/yongman/tidis# make
go build -o bin/tidis-server cmd/server/*
root@48d5a178290c:/go/src/github.com/yongman/tidis# ./bin/tidis-server -conf ./config.toml -backend pd:2379

```
Then you can connect `localhost:5379` by redis client.

After finish dev, run following command will destroy all docker containers.

```
~ docker-compose -f docker-compose-dev.yml down 
WARNING: The TIDIS_DIR_SRC variable is not set. Defaulting to a blank string.
Stopping tidis-docker-compose_tidis_1 ... done
Stopping tidis-docker-compose_tikv_1  ... done
Stopping tidis-docker-compose_pd_1    ... done
Removing tidis-docker-compose_tidis_1 ... done
Removing tidis-docker-compose_tikv_1  ... done
Removing tidis-docker-compose_pd_1    ... done
Removing network tidis-docker-compose_default
```