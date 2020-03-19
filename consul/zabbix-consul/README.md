# Consul Zabbix Monitoring

## How it works

Zabbix server (or Zabbix proxy) is executing consul.py as "External check"
item. Consul.py is connecting to Consul server (or cluster) API and
performs:

- Node Discovery
- Node Status Check
- Service Discovery
- Service Status Check

Supports:
- HTTP Basic Auth
- Token Auth

## Configure

- Copy consul.py to Zabbix server or Zabbix proxy "ExternalScripts"
  directory and set correct permissions (chmod 755 consul.py)
- Import consul_template.xml
- Create consul host
	- Add MACRO: {$CONSUL_URI} = http://user:pass@consulhost:8500/token
	- Link "Consul Template" to host
