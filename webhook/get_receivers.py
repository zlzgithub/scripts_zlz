# coding=utf-8
import json
from configobj import ConfigObj


def get_receivers(alertname, instance, media="re"):
    cfg = ConfigObj("receivers.cfg")
    comm_re = []
    alert_comm_re = []
    alert_re = []
    try:
        comm_re = cfg.get("All").get("Common").get(media)
    except:
        pass

    try:
        alert_comm_re = cfg.get(alertname).get("Common").get(media)
    except:
        pass

    try:
        alert_re = cfg.get(alertname).get(instance).get(media)
    except:
        pass

    receivers = list(set(comm_re + alert_comm_re + alert_re))
    if "wxre" == media:
        wxid_dict = json.load(open("wxid.json", "r"))
        return [ wxid_dict.get(rece) for rece in receivers ]
    else:
        return receivers


if __name__ == '__main__':
    print get_receivers("hostCpuUsageAlert", "cvm001")
    print get_receivers("hostCpuUsageAlert", "cvm001", media="wxre")

