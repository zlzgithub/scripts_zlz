#!/usr/bin/python2
# coding=utf8
import sys 
import json
from flask import Flask, request, render_template
from mail2 import send_mail
from wx import wx
from log import logger
from get_receivers import get_receivers

reload(sys)
sys.setdefaultencoding('utf-8') 
app = Flask(__name__)


def do_sendmail():
    try:
        data = json.loads(request.data)
        logger.info(render_template('mail.html.j2', data=data))
        to_list = get_receivers(data.get("commonLabels").get("alertname"),
                                data.get("commonLabels").get("instance"),
                                media='re')
        subject = "Prometheus Alert"
        if to_list:
            send_mail(to_list, subject, render_template('mail.html.j2', data=data))
    except Exception as e:
        print e


def do_sendmsg():
    try:
        data = json.loads(request.data)
        logger.info(render_template('wx.html.j2', data=data))
        to_list = get_receivers(data.get("commonLabels").get("alertname"),
                                data.get("commonLabels").get("instance"),
                                media='wxre')
        subject = "Prometheus Alert:"
        for receiver in to_list:
            wx(receiver, subject, render_template('wx.html.j2', data=data))
    except Exception as e:
        print e


@app.route('/mail', methods=['POST'])
def sendmail():
    do_sendmail()
    return "ok"


@app.route('/wx', methods=['POST'])
def sendmsg():
    do_sendmsg()
    return "ok"


@app.route('/wxmail', methods=['POST'])
def wxmail():
    do_sendmsg()
    do_sendmail()
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0")

