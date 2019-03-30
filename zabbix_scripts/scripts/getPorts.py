#!/usr/bin/env python
#coding:utf-8
import os, json, re


mypath = os.path.dirname(os.path.realpath(__file__))
port_list = []
port_dict = {"data":None}

with open('%s/ports.ini' % mypath, 'r') as f:
    for line in f.readlines():
        line = line.strip()
        if line:
            try:
                port_srv = line.split(':')
                port_list.append({"{#TCP_PORT}": port_srv[1].strip(),
                                  "{#SERVICE}": port_srv[0].strip()})
            except:
                pass

port_dict["data"] = port_list
json_str = json.dumps(port_dict, sort_keys=True, indent=4)

# del the blanks in the end of each line
p = re.compile("\s+$")
for line in json_str.split('\n'):
    ss = re.sub(p, "", line)
    print ss

