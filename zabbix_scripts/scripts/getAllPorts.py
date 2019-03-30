#!/usr/bin/env python
#coding:utf-8
import os, json, re


port_list = []
port_dict = {"data":None}
cmd = """netstat -tnlp |awk '{print $4}' |awk -F: """ \
      """'{if($NF~/^[0-9]*$/) print $NF}' |sort |uniq 2>/dev/null"""
local_ports = os.popen(cmd).readlines()

for port in local_ports:
    pdict = {}
    pdict["{#TCP_PORT}"] = port.replace("\n", "")
    pdict["{#SERVICE}"] = pdict["{#TCP_PORT}"] + "_srv"
    port_list.append(pdict)

port_dict["data"] = port_list
json_str = json.dumps(port_dict, sort_keys=True, indent=4)

# del the blanks in the end of each line
p = re.compile("\s+$")
for line in json_str.split('\n'):
    ss = re.sub(p, "", line)
    print ss

