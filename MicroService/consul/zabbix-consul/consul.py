#!/usr/bin/env python
import sys
import json
import urlparse
import argparse
import requests
import traceback
from requests.auth import HTTPBasicAuth

parser = argparse.ArgumentParser(description='Zabbix Consul')
parser.add_argument('-u', dest='server_uri', required=True,
                    help='http://user:pass@localhost:8500/token')
parser.add_argument('-n', dest='node_name',
                    help='Node Name')
parser.add_argument('-s', dest='service_name',
                    help='Service Name')
parser.add_argument('-a', dest='action', required=True,
                    choices=[
                        'nodeDiscovery', 'nodeStatus',
                        'serviceDiscovery', 'serviceStatus'
                    ],
                    help='Action')
parser.add_argument('-d', dest='debug', action='store_true', default=False,
                    help='Debug')
args = parser.parse_args()


def fetch(url, ret={}):
    if args.debug:
        print("Sending request to {}".format(url))

    try:
        headers = {}
        auth = None
        if server_token:
            headers = {'X-Consul-Token': server_token}
        if server_user and server_pass:
            auth = HTTPBasicAuth(server_user, server_pass)

        r = requests.get(url, headers=headers, auth=auth)
        if r.status_code != 200:
            if args.debug:
                print(r.status_code, r.text)
                sys.exit(1)
            return ret
        return json.loads(r.text)

    except Exception as e:
        if args.debug:
            print(str(e))
            print(traceback.format_exc())
            sys.exit(1)
        return ret

def nodeDiscovery(url):
    discovery_list = {}
    discovery_list['data'] = []


    nodes = fetch(url)

    for node in nodes:
        if node['Checks'][0]['CheckID'] == 'serfHealth':
            zbx_item = {
                "{#NODEID}": node['Node']['ID'],
                "{#NODENAME}": node['Node']['Node'],
                "{#NODEADDRESS}": node['Node']['Address'],
                "{#NODEDATACENTER}": node['Node']['Datacenter']
            }
            discovery_list['data'].append(zbx_item)
    print(json.dumps(discovery_list, indent=4, sort_keys=True))

def nodeStatus(url):
    node = fetch(url)
    if len(node) == 0:
        print(0)
        sys.exit(0)

    try:
        status = 1 if node[0]['Status'] == 'passing' else 0
        print(status)
    except Exception as e:
        if args.debug:
            print(str(e))
            print(traceback.format_exc())
            sys.exit(1)
        print(0)

def serviceDiscovery(url):
    discovery_list = {}
    discovery_list['data'] = []


    services = fetch(url)

    for service in services:
        zbx_item = {
            "{#SERVICENAME}": service
        }
        discovery_list['data'].append(zbx_item)
    print(json.dumps(discovery_list, indent=4, sort_keys=True))

def serviceStatus(url):
    services = fetch(url)
    if len(services) == 0:
        print(0)
        sys.exit(0)

    try:
        for service in services:
            for check in service['Checks']:
                if check['Status'] != 'passing':
                    print(0)
                    return

        print(1)
    except Exception as e:
        if args.debug:
            print(str(e))
            print(traceback.format_exc())
            sys.exit(1)
        print(0)


try:
    uri = urlparse.urlparse(args.server_uri)
    server_scheme = uri.scheme
    server_address = uri.hostname
    server_port = uri.port if uri.port else 8500
    server_user = uri.username
    server_pass = uri.password
    server_token = uri.path.strip('/') if uri.path not in ['', '/'] else None
except Exception as e:
    print(str(e))
    print("Invalid uri {}".format(args.server_uri))
    parser.print_help()
    sys.exit(1)

if args.action == 'nodeDiscovery':
    nodeDiscovery("{}://{}:{}/v1/health/service/consul".format(
        server_scheme,
        server_address,
        server_port
    ))
elif args.action == 'nodeStatus':
    if not args.node_name:
        print("-n <node_name> required")
        sys.exit(1)
    else:
        nodeStatus("{}://{}:{}/v1/health/node/{}".format(
            server_scheme,
            server_address,
            server_port,
            args.node_name
        ))
elif args.action == 'serviceDiscovery':
    serviceDiscovery("{}://{}:{}/v1/catalog/services".format(
        server_scheme,
        server_address,
        server_port
    ))
elif args.action == 'serviceStatus':
    if not args.service_name:
        print("-s <service_name> required")
        sys.exit(1)
    else:
        serviceStatus("{}://{}:{}/v1/health/service/{}".format(
            server_scheme,
            server_address,
            server_port,
            args.service_name
        ))
