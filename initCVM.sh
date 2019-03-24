#!/bin/sh

set -x


yum install httpd -y
yum install git -y
yum install gcc gcc-c++ -y
yum install tree -y
yum install telnet -y

cat <<EOF >> /etc/profile
export JAVA_HOME=/usr/local/jdk1.8.0_191
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

export CATALINA_HOME=/usr/local/apache-tomcat-8.5.38
export PATH=$CATALINA_HOME/bin:$PATH
EOF

source /etc/profile


