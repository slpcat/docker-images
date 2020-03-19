# zabbix-enhanced-templates
Enhanced templates for Zabbix server. These templates adds new items and triggers for deep OS monitoring.

## List of templates

### Template Linux Limits

This template get the results of ulimit command.

### Template Linux Memory

This template was built using [vm.memory.size] (https://www.zabbix.com/documentation/2.4/manual/appendix/items/vm.memory.size_params) function and all of its parameters.

### Template Linux Processes

This template uses [get_proc_stats.sh script] (https://github.com/galindro/zabbix-enhanced-templates/blob/master/scripts/get_proc_stats.sh) to search the PID of a given process or processes by using LLD discovery. For discovery, the script will need as first parameter, a JSON string and, as second parameter, the string discovery. There is another parameter called net_discovery that is used by *Get processes with PID with network interfaces* discovery rule. This feature builds the LLD json with OS network interfaces for processes network statistics.

```bash
# Script help:

 Usage:

  For discovery: ./get_proc_stats.sh <json> discovery or ./get_proc_stats.sh <json> net_discovery
   * Example #1: Discover process pids with exactly names "trivial-rewrite" and "qmgr" that are owned by postfix and discover process pids with "zabbix" on its name and "/usr/bin" regexp on its entire command line -> ./get_proc_stats.sh '{"postfix":{"exactly":["trivial-rewrite","qmgr"]},"root":{"name":["zabbix","ssh"],"cmd":["/usr/bin"]}}' discovery
   * Example #2: ./get_proc_stats.sh '{"postfix":{"exactly":["trivial-rewrite","qmgr"]},"root":{"name":["zabbix","ssh"],"cmd":["/bin/sh"]}}' discovery

  For counters: ./get_proc_stats.sh <pid> <options>
   * Example #1: Retreive process file descritors quantity -> ./get_proc_stats.sh 928 fd
   * Example #2: Retreive process state -> ./get_proc_stats.sh 928 state
```

The script uses [smem](https://www.selenic.com/smem/) to get processes detailed memory usage and [jq](https://stedolan.github.io/jq/) for build and parse json data.

To get PID from processes, it uses [pgrep](http://linux.die.net/man/1/pgrep). So, the script will execute pgrep acording to the informed keys on json parameter of discovery/net_discovery process:

"name" key will use execute this pgrep command: 
```bash
pgrep <string_defined_in_json> -u <user_defined_in_json> -l
```
"cmd" key will use execute this pgrep command: 
```bash
pgrep -f <string_defined_in_json> -u <user_defined_in_json> -l
```

"exactly" key will use execute this pgrep command: 
```bash
pgrep -x <string_defined_in_json> -u <user_defined_in_json> -l
```

The triggers associated with the template are configurable via user MACROS. The default values are set in the template, but they can be changed per host. This is the list of MACROS:

![](https://raw.githubusercontent.com/galindro/zabbix-enhanced-templates/master/template_linux_processes_macros.png)

### Template Linux Vulnerabilities

This template is intended to show common vulnerabilities found in some Linux packages and libraries.

### Template Linux NTP

Use this template to monitor linux ntpd deamon. This template uses the following scripts and userparameter files:

  - [ntp_discovery.sh](https://github.com/galindro/zabbix-enhanced-templates/blob/master/scripts/ntp_discovery.sh): used to discover the ntp peers
  - [ntp_erros.sh](https://github.com/galindro/zabbix-enhanced-templates/blob/master/scripts/ntp_errors.sh): used to calculate the number of reachability errors. It is a customized version of [ntp_packets.sh](http://www.linuxjournal.com/article/6812)
  - [userparameter_ntp.conf](https://github.com/galindro/zabbix-enhanced-templates/blob/master/zabbix_agentd.d/userparameter_ntp.conf): used by zabbix agent

The scripts must be placed in /etc/zabbix/scripts. If you want to change the destiny, you will need to changed the [userparameter_ntp.conf](https://github.com/galindro/zabbix-enhanced-templates/blob/master/zabbix_agentd.d/userparameter_ntp.conf) file to reflect the new path.

## Installation

### Zabbix Server

* Import the required value mappings into database

```bash 
mysql -h $MYSQL_HOST -u $MYSQL_USER -p $MYSQL_DATABASE < sql/value-mappings*.sql
```

* Disable vm.memory.* items from any template that is used by hosts that you are planning to associate the Template Linux Memory to avoid duplicated key problem

* Import the templates through Zabbix web interface

### Zabbix Client

* Run this script on each monitored host:

```bash 
apt-get update && apt-get -y install smem jq
mkdir -p /etc/zabbix/scripts/
cd /etc/zabbix/scripts/
wget https://raw.githubusercontent.com/galindro/zabbix-enhanced-templates/master/scripts/get_proc_stats.sh
chmod 0700 get_proc_stats.sh
```

## Configuration

### Template Linux Processes

* Add it to the host
* Create a user macro called {$PROCS_TO_SEARCH} with the required JSON for processes search
* Wait for discovery process to find the PIDs

## Tests

This software was tested on these envirionments:

### Server
* Ubuntu 14.04
* Zabbix 2.4.6

### Client
* Ubuntu 14.04 and Ubuntu 12.04
* Zabbix agent 2.2.10 and 2.2.8

# License

GNU GENERAL PUBLIC LICENSE Version 2, June 1991
