#!/bin/sh


if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
    echo ""
    echo "Usage:"
    echo "sh $0 <url> <port> [<timespace>]"
    echo "e.g."
    echo "sh $0 \"www.baidu.com\" 8080 2"
    echo ""
    exit 0
fi

test_url=$1
port=$2
inter=$3

if [ -z "$port" ]; then
    exit 0
fi

# 默认间隔2s
if [ -z "$inter" ]; then
    inter=2
fi

# 限制inter，最大间隔10s
if [ $inter -gt 10 ]; then
    inter=10
fi

# 检测
rm -f ./resp
(curl -sI "$test_url" >./.resp) &

sleep $inter

if [ -n "$(sed -n '/200 OK/p' .resp)" ]; then
    echo "OK!"
    echo ""
    target_pid=$(netstat -alntp |grep ':'"$port"'\s' |awk '{print $NF}' |awk -F/ '{print $1}')
    if [ -n "$target_pid" ]; then
        echo "target pid: $target_pid"
    fi
else
    echo "Time-out"
    echo ""
    target_pid=$(netstat -alntp |grep ':'"$port"'\s' |awk '{print $NF}' |awk -F/ '{print $1}')
    if [ -n "$target_pid" ]; then
        echo "target pid: $target_pid"
    fi
fi

