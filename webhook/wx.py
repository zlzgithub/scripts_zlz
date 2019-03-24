#!/usr/bin/python2
# coding=utf-8

import logging
import requests,sys,json
import urllib3
from log import logger

urllib3.disable_warnings()
reload(sys)
sys.setdefaultencoding('utf-8')


def GetTokenFromServer(corpid,secret):
    Url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken"
    Data = {
        "corpid":corpid,
        "corpsecret":secret
    }
    r = requests.get(url=Url,params=Data,verify=False)
    if r.json()['errcode'] != 0:
        return False
    else:
        Token = r.json()['access_token']
        file = open('/tmp/zabbix_wechat_config.json', 'w')
        file.write(r.text)
        file.close()
        return Token


def SendMessage(user,Agentid,subject,content):
    try:
        file = open('/tmp/zabbix_wechat_config.json', 'r')
        Token = json.load(file)['access_token']
        file.close()
    except:
        Token = GetTokenFromServer(corpid, secret)

    n = 0
    Url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s" % Token
    Data = {
        "touser": user, # 企业号中的用户帐号，在zabbix用户Media中配置，如果配置不正常，将按部门发送。
        # "totag": Tagid, # 企业号中的标签id，群发使用（推荐）
        # "toparty": Partyid, # 企业号中的部门id，群发时使用。
        "msgtype": "text", # 消息类型。
        "agentid": Agentid, # 企业号中的应用id。
        "text": {
            "content": subject + '\n' + content
        },
        "safe": "0"
    }
    r = requests.post(url=Url,data=json.dumps(Data),verify=False)
    while r.json()['errcode'] != 0 and n < 4:
        n+=1
        Token = GetTokenFromServer(corpid, secret)
        if Token:
            Url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=%s" % Token
            r = requests.post(url=Url,data=json.dumps(Data),verify=False)

    print "SendMessage end"
    return r.json()


def wx(user, subject, content):
    logger.info("user={} subject={} content={}".format(user, subject, content))
    corpid = "xxxxxxxxxxxxx" # CorpID是企业号的标识
    global corpid
    secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # secret是管理组凭证密钥
    global secret
    # Tagid = "xxx" # 通讯录标签ID
    agentid = "xxxx" # 应用ID
    # Partyid = "xxx" # 部门ID
    Status = SendMessage(user, agentid, subject, content)


if __name__ == '__main__':
    user = sys.argv[1]
    subject = str(sys.argv[2])
    content = str(sys.argv[3])
    wx(user, subject, content)

