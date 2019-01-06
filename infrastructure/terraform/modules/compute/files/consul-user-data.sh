#!/bin/bash
LOCAL_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sed -i "s/SERVER_IP/\"$LOCAL_IP\"/g" /etc/consul.d/consul.json
systemctl enable consul
systemctl start consul
