#!/bin/sh


exporter_path=/usr/local/prom_exporter
mkdir -p $exporter_path

app_fullname=mysqld_exporter-0.11.0.linux-amd64
app_url=https://github.com/prometheus/mysqld_exporter/releases/download/v0.11.0/${app_fullname}.tar.gz
app_name=mysqld_exporter

cd $exporter_path
if [ ! -d "${app_fullname}" ]; then
    wget $app_url
    tar -xf ${app_fullname}.tar.gz
    rm -f ${app_fullname}.tar.gz
fi

cd ${app_fullname}/

echo "Need to create a new mysql user named [mysqld_exporter] ..."
read -p "Input an existed mysql user:" mysql_user
read -s -p "Input the password of [$mysql_user]:" mysql_pass
echo ""
if [ -z "$mysql_user" ] || [ -z "$mysql_pass" ]; then
    echo "Canceled"
    exit 1
fi

read -s -p "Input the mysql password for the new user [mysqld_exporter]:" exporter_pass
echo ""
if [ -z "$exporter_pass" ]; then
    echo "The password of mysqld_exporter will be set as default."
    exporter_pass=mysqld_exporter
fi

# check mysql version & create user
mysql_ver=$(mysql --version |sed 's/^.*Distrib\s*//' |sed 's/^\([0-9.]\+\).*$/\1/')
sorted_ver=$(echo "$mysql_ver
5.6.0" |sort)
ver1=$(echo "$sorted_ver" |head -n1)
if [ "$ver1" != "5.6.0" ]; then
    echo "mysql version < 5.6.0"
    mysql -u"$mysql_user" -p"$mysql_pass" <<EOF1
grant process, replication client, select on *.* to mysqld_exporter@'localhost' identified by "$exporter_pass";
flush privileges;
EOF1
    if [ $? -ne 0 ]; then
       echo "create user failed..."
       echo "create user failed..."
       echo "create user failed..."
       echo "create user failed..."
       echo "create user failed..."
       exit 1
    fi
else
    echo "mysql version >= 5.6.0"
    mysql -u"$mysql_user" -p"$mysql_pass" <<EOF
create user if not exists mysqld_exporter@'localhost' identified by "$exporter_pass";
grant process, replication client, select on *.* to mysqld_exporter@'localhost';
flush privileges;
EOF
    if [ $? -ne 0 ]; then
       echo "create user failed..."
       echo "create user failed..."
       echo "create user failed..."
       echo "create user failed..."
       echo "create user failed..."
       exit 1
    fi
fi

cat <<EOF >.my.cnf
[client]
user=mysqld_exporter
password=$exporter_pass
EOF

# # run mysqld_exporter:
# nohup ./mysqld_exporter --config.my-cnf="./.my.cnf" >nohup.out 2>&1 &

# # or:
# nohup ./mysqld_exporter --config.my-cnf="./.my.cnf" >/dev/null 2>&1 &

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
command=$exporter_path/${app_fullname}/${app_name} --config.my-cnf="$exporter_path/${app_fullname}/.my.cnf"
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

