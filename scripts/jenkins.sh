#!/bin/bash
apt -qq update && apt -qq install -y openjdk-17-jdk maven wget curl unzip

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key > /usr/share/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

apt -qq update && apt -qq install -y jenkins
###