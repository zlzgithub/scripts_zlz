#!/bin/sh

exporter_path=/usr/local/prom_exporter
mkdir -p $exporter_path

cd $exporter_path
app_fullname=node_exporter-0.17.0.linux-amd64
app_url=https://github.com/prometheus/node_exporter/releases/download/v0.17.0/${app_fullname}.tar.gz
app_name=node_exporter

if [ ! -d "$app_fullname" ]; then
    wget $app_url
    tar -xf ${app_fullname}.tar.gz
    rm -f ${app_fullname}.tar.gz
fi

# # run node_exporter:
# nohup ./$app_name >nohup.out 2>&1 &

# # or:
# #nohup ./$app_name >/dev/null 2>&1 &

# # or run by supervisord:

super_cfg_dir=$(cd /etc; cd $(dirname $(sed -n '/^files/p' /etc/supervisord.conf |sed 's/^.*=\s*//')); pwd)
super_cfg_suffix=$(sed -n '/^files/p' /etc/supervisord.conf |sed 's/^.*\.//')

if [ -z "$super_cfg_dir" ]; then
    yum install supervisor -y
    super_cfg_dir=/etc/supervisord.d
    super_cfg_suffix=ini
fi

super_cfg=${super_cfg_dir}/${app_name}.${super_cfg_suffix}

cat <<EOF > $super_cfg
[program:$app_name]
command=$exporter_path/$app_fullname/$app_name
directory=$exporter_path/$app_fullname
user=root
startsecs=3
redirect_stderr=true
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=3
stdout_logfile=/var/log/${app_name}.log
EOF

if ps -ef |grep supervisord |grep -v grep; then
    supervisorctl update
else
    supervisord -c /etc/supervisord.conf
fi

sleep 1
if ps -ef |grep "$app_name" |grep -v grep; then
    echo "OK!"
else
    echo "start $app_name failed"
fi

