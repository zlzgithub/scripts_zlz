### Prometheus告警——基于webhook的邮件/企业微信通知



> webhook通过Python Flask实现，默认监听端口5000；提供/wx和/mail和/wxmail三个接口。



- 使用方法：

```sh
nohup python alert.py >nohup.out 2>&1 &
```



- 修改/添加接收人

receivers.cfg：记录各种告警名称对应的邮件收件人（re=)、微信消息接收人(wxre=)；须行末逗号

wxid.json：记录员工邮箱和企业微信ID的对应关系



- 测试：

```sh
python testAlert.py
```
