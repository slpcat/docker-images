#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os,sys,collections
import subprocess as sp
import json

class FlumeBin:

    zkBinDir="/usr/local/apache-zookeeper/current/bin"
    #zkBinDir="/usr/share/zookeeper/bin"
    #flumeConfDir="/var/lib/bde/flume/conf"
    flumeConfDir="/config"
    def __init__(self):        
        pass

    def get_value(self, value):
        try:
            return os.environ[value[1:]] if value.startswith('$') else value;
        except KeyError as keyError:
            raise Exception(("%s not available in environment" % value))
      
    def fromJson(self, flume_commands_file_name=None):
        if(flume_commands_file_name==None):
            raise ValueError("the absolute path to the flume command definition cannot be none");

        flume_commands_file_name = os.path.abspath(flume_commands_file_name);

        with open(flume_commands_file_name) as flume_commands_file:
            flume_commands = json.load(flume_commands_file,object_pairs_hook=collections.OrderedDict);
            zkConnString = None; 
            zkBasePath = None;
            confFile = None;
            name = None;
            dev_null = open(os.devnull, 'w')
            for command in flume_commands:                
                for option,value in command.items():
                    if option == "-n" or option == "--name":
                        name = self.get_value(value);
                    if option == "-z" or option == "--zkConnString":
                        zkConnString = self.get_value(value);
                    if option == "-p" or option == "--zkBasePath":
                        zkBasePath = self.get_value(value);
                        zkBasePath = zkBasePath if zkBasePath.startswith("/",0,1) else ("/%s" % zkBasePath)
                    if option == "-f" or option == "--conf-file":
                        confFile = self.get_value(value);

                if name == None:
                    raise Exception("missing required option 'agent name': [-n, --name]")
                if confFile == None and zkConnString == None:
                    raise Exception("missing required option 'agent config file' if no zookeeper url specified: [-f, --conf-file]")
                if zkConnString != None:
                    with open(("%s/%s" % (self.flumeConfDir,name)),'r+') as flume_config:
                        if zkBasePath != None:                               
                          create_chroot=[ ("%s/zkCli.sh" % self.zkBinDir), "-server", zkConnString, "create", zkBasePath ]
                          exit_code = sp.call(create_chroot, stdout=dev_null, stderr=dev_null, close_fds=True)

                        upload_call=[ ("%s/zkCli.sh" % self.zkBinDir), "-server", zkConnString, "create",("%s/%s" % ((zkBasePath if zkBasePath != None else ""),name)), ("%s" % flume_config.read().rstrip('\n')) ];
                        exit_code = sp.call(upload_call, stderr=dev_null, close_fds=True)
                        pass
                    
                command_call=[]
                [command_call.extend([k,self.get_value(v)]) for k,v in command.items()]
                command_call = [var for var in command_call if var]
                if command_call[0] == "bash":
                    exit_code = sp.call(command_call, stdout = sp.PIPE, stderr=dev_null,close_fds=True)
                else:
                    raise Exception("json construct must start with 'bash' and the path to a flume binary");
                
        pass;
    
if __name__ == '__main__':
    if(len(sys.argv)==2):
        flumeBin = FlumeBin();
        try :
            flumeBin.fromJson(sys.argv[1]);
        except Exception as e:
            print(e);
    else:
        print("Please specify a flume command json")
