MyDumper
--------

This is a gcavalcante8808/mydumper docker image based no alpine 3.6 and Percona MyDumper.

Supported Tags and respective Docker Links
------------------------------------------

 * mydumper 0.9.1 (([mydumper0.9.1/Dockerfile](https://github.com/gcavalcante8808/docker-mydumper/blob/0.9.1/Dockerfile)))

How to see it In Action
-----------------------

You can use ([docker-compose](https://docs.docker.com/compose/install/)) to spin up a MySQL Server and the mysqldumper using the docker-compose.yml file provided in this project in the following way:

```
mkdir test && cd test
wget https://raw.githubusercontent.com/gcavalcante8808/docker-mysqldumper/master/docker-compose.yml
docker-compose up
```

The container for mydumper will start, create the backup then exit with status 0. (You can see the exit code with `docker ps` and logs with `docker logs <CONTAINER>`.

The backups are created with --compress and in the following folder pattern:

<BACKUP_FOLDER>/<DB_NAME>-<DATE>


Needed Environment Variables
----------------------------

The container uses the following environment variables (theh bold ones are **required**) :

 * **DB_HOST**: the IP or hostname of the mysql Server;
 * DB_USER: a user with 'RELOAD' privilege. If not provided, assumes root;
 * DB_NAME: the name of the db that will be saved. Same value as DB_USER if not provided;
 * **DB_PASSWORD**: the password for the user.

ROADMAP
-------

The Following features mark the roadmap for a more usefull (Aka 1.0) version:

 * Support for S3 Backups with endpoint options (minio, do spaces, aws, etc);
 * DCron support for schedules;
 * Backup All Databases instead of just one.

Author
------

Author: Gabriel Abdalla Cavalcante Silva (gabriel.cavalcante88@gmail.com)
