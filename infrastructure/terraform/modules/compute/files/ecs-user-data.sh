#!/bin/bash
echo ECS_CLUSTER=prod_cluster >> /etc/ecs/ecs.config

docker pull consul:latest
LOCAL_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul agent -bind=$LOCAL_IP -retry-join="provider=aws tag_key=consul tag_value=server"
