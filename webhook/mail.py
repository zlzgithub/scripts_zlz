#!/usr/bin/python
#coding:utf-8
import smtplib
from email.mime.text import MIMEText
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

mail_host = 'smtp.163.com'
mail_from = 'xxx@163.com'
mail_user = 'xxx'
mail_pass = 'xxxxxx'
mail_postfix = '163.com'


def send_mail(to_list, subject, content):
    # msg = MIMEText(content, 'plain', 'utf-8')
    msg = MIMEText(content, 'html')
    msg['from'] = mail_from
    msg['to'] = ",".join(to_list)
    msg['subject'] = subject
    try:
        s = smtplib.SMTP_SSL(mail_host, 465)
        s.login(mail_from, mail_pass)
        s.sendmail(mail_from, to_list, msg.as_string())
        print "OK!"
        s.close()
    except Exception, e:
        print str(e)

