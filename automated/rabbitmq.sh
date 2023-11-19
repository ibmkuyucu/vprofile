#!/bin/bash
yum install -y epel-release wget
# yum update -y
cd /tmp/
yum -y install centos-release-rabbitmq-38
yum --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator
systemctl restart rabbitmq-server
