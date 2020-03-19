# Flume Docker

Versions used in this docker image:
* Flume Version: apache-flume-1.7.0-SNAPSHOT-bin.tar.gz
* Zookeeper Version: 3.5.2-alpha
* Java 1.8.0_72
 
Image details:
* Installation directory: /app (i.e: /usr/local/apache-flume/current)
* 
## Flume Docker image

To start the Flume Docker image:

 ```bash
docker run -i -t bde2020/flume /bin/bash
```
To build the Flume Docker image:

 ```bash
git clone https://github.com/big-data-europe/docker-flume.git
docker build -t bde2020/flume .
```

Flume image notes
 * Docker Image directory structure and files
  * /app (symlink to : /usr/local/apache-flume/flume-1.6.0)
  * /config (symlink to : /usr/local/apache-flume/flume-1.6.0/conf)
  * /app/bin/flume-init (=/usr/local/apache-flume/flume-1.6.0/bin/flume-init, see below)

To run this Flume Docker with the BDE platform

* To include this docker image into an arbitrary BDE pipeline, it is necessary to extend the bde2020/flume image, adding a flume-startup.json and flume configuration to the /config directory. 
   ```bash
   FROM bde2020/flume:latest

   ADD flume-startup.json /config/
   ADD your-flume-agent /config/
   ```
* For reference of the naming conventions find an excerpt of the corresponding flume agent below
   ```bash
   your-flume-agent.sources = dirSource
   your-flume-agent.channels = memChannel1 
   your-flume-agent.sinks = kafkaSink
   your-flume-agent.sources.dirSource.type = spooldir   
   ```
* The flume-startup.json file contains the startup command and options for flume in json format, an example is given below
 
   ```bash
   [
     {
       "bash":"/app/bin/flume-ng",
       "agent":"",
       "--name":"$FLUME_AGENT",
       "--conf":"/config/",
       "-z":"192.168.88.219:2181,192.168.88.220:2181",
       "-p":"/flume"
     }
   ]
   ```
  
  * Notes on flume-startup.json
    * The included flume-bin.py will read the command in order and issue the resulting command.
    * First key value pair must be "bash" and "/app/bin/flume-ng" (or another binary from the flume bin directory)
    * It is possible to include environmental variables in flume-startup.json, flume-bin.py will retrieve any value starting with "$" from the environment.
    * All other options are dependent on how flume needs to be started. Requirements for certain options derive from the flume-ng binary. Check out FlumeUserGuide (above) to learn more.
    * In case a "chroot" is used in Apache Zookeeper using Apache Flume's -p option it must start with a slash.
    * In case the -z option is used flume-bin.py will upload the contents the flume configuration file to a zookeeper node with the name specified by the --name option.
    * Important note on the naming convention: the value for the --name option for the startup command, the file name of the flume configuration (added to /config) and the name of the agent inside said flume configuration must be the same, when zookeeper is used.
    * In case additional java libraries for the defined Apache Flume Pipeline are required, it is necessary to include those libraries in the extension of this docker image and add them to an arbitrary path. This path must then be given as an option in flume-startup.json using the --plugins-path option. See the UserGuide for more details about using plugins.

  * To integrate your Apache Flume extension with the BDE platform use the following docker compose snippet. Note that a full example of an Apache Flume extension can be found here: https://github.com/big-data-europe/pilot-sc6-cycle2/tree/master/sc6-flume, the full set of docker swarm instructions can be found here: https://github.com/big-data-europe/pilot-sc6-cycle2/blob/master/docker-compose.yml
     ```bash
     your-flume:
       image: "your/flume-extension"
       depends_on:
         - your_zookeeper_1
         - your_zookeeper_2
         - your_zookeeper_3
         - your-kafka-1
         - your-kafka-2
         - your-kafka-3
       command: "bash -c /app/bin/flume-init"
       volumes:
         - ./data:/var/lib/bde/flume/sc6/budgets
       environment:
         - "constraint:node==your-hosting-server"     
     ```
Start the image with (with respect to the above flume-startup.json)
```bash
export FLUME_AGENT=your-flume-agent && /app/bin/flume-init
```
