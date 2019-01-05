#!/bin/bash
yum update -y
LOCAL_IP=curl http://169.254.169.254/latest/meta-data/local-ipv4
sed -i "s/SERVER_IP/$LOCAL_IP/g" /etc/systemd/system/consul.service
