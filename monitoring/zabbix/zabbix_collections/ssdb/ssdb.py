#!/bin/env python
 
import sys,json,socket,re
from SSDB import SSDB
 
def get_stats(ip,port):
  ssdb = SSDB(ip, port)
  info = ssdb.request('info',['cmd'])
  result= info.data[1:]
  return result
 
def discovery_cmd(info):
  d={'data':[]}
  for i in range(0,len(info),2):
    if info[i].find('cmd') != -1:
      d['data'].append({'{#SSDBCMD}':info[i]})
 
  return json.dumps(d)
 
def check(ip,port):
  ssdb = SSDB(ip, port)
  try:
    ssdb.request('set', ['zabbix', '123'])
    ssdb.request('get', ['zabbix'])
    return 1
  except:
    return 0
 
if __name__ == '__main__':
  ip = socket.gethostbyname(socket.getfqdn(socket.gethostname()))
  port = 8888
  stats = get_stats(ip,port)
  res = {}
  for i in range(0,len(stats),2):
    if stats[i] == 'replication':
      stats[i] = stats[i]+'.'+stats[i+1].split()[0]
    res[stats[i]] = stats[i+1]
  
  cmd = sys.argv[1]
  filter = sys.argv[2] if len(sys.argv) > 2 else ''
 
  if cmd  == 'discover':
    print discovery_cmd(stats)
  elif cmd.find('cmd') != -1:
    p = re.compile('(\w+):\s+(\d+)\s+(\w+):\s+(\d+)\s+(\w+):\s+(\d+)')
    m = p.match(res[cmd])
    d=dict(zip(m.group(1,3,5),m.group(2,4,6)))
    #print d[filter]
    print d.get(filter,'not support')
  elif cmd == 'replication.client':
    for i in res['replication.client'].split('\n'):
      if i.split(':')[0].strip() == filter:
        print i.split(':')[1].strip()
  elif cmd == 'binlogs':
    print res['binlogs'].split('\n')[-1].split(':')[-1].strip()
  elif cmd == 'available':
    print check(ip,port)
  else:
    print res.get(cmd,'not support')
