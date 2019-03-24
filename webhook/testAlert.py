# coding=utf8
import requests, json


MSG = {
    "status": "resolved", 
    "groupLabels": {
        "alertname": "hostCpuUsageAlert"
    }, 
    "groupKey": "{}:{alertname=\"hostCpuUsageAlert\"}", 
    "commonAnnotations": {
        "description": "cvm001 CPU usage above 20% (current value: 99.99999999999545)", 
        "summary": "Instance cvm001 CPU usgae high"
    }, 
    "alerts": [
        {
            "status": "resolved", 
            "labels": {
                "instance": "cvm001", 
                "monitor": "codelab_monitor", 
                "alertname": "hostCpuUsageAlert", 
                "severity": "page"
            }, 
            "endsAt": "2019-03-18T10:15:17.007392654Z", 
            "generatorURL": "http://xxx:9090/graph?g0.expr=sum+by%28instance%29+%28avg+without%28cpu%29+%28irate%28node_cpu_seconds_total%7Bmode%21%3D%22idle%22%7D%5B5m%5D%29%29%29+%2A+100+%3E+20&g0.tab=1", 
            "startsAt": "2019-03-18T10:14:47.007392654Z", 
            "annotations": {
                "description": "cvm001 CPU usage above 20% (current value: 99.99999999999545)", 
                "summary": "Instance cvm001 CPU usgae high"
            }
        }
    ], 
    "version": "4", 
    "receiver": "mail", 
    "externalURL": "http://xxx:9093", 
    "commonLabels": {
        "instance": "cvm001", 
        "monitor": "codelab_monitor", 
        "alertname": "hostCpuUsageAlert", 
        "severity": "page"
    }
}

r = requests.post(data=json.dumps(MSG), url="http://127.0.0.1:5000/mail", headers={'Connection':'close'})
print r.status_code

