#!/bin/bash

cat <<EOT> /etc/sysctl.d/sonar.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
EOT

cat <<EOT> /etc/security/limits.d/sonar.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    409
EOT

apt -qq update -y && apt -qq install -y wget zip nginx openjdk-11-jdk

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt -qq update -y && apt -qq install -y postgresql postgresql-contrib

echo "postgres:admin123" | chpasswd
runuser -l postgres -c "createuser sonar"
sudo -iu postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -iu postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -iu postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
systemctl restart  postgresql

mkdir -p /sonarqube/
cd /sonarqube/
wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
unzip -qo sonarqube-8.3.0.34182.zip -d /opt/
mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube
groupadd sonar
useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
chown sonar:sonar /opt/sonarqube/ -R
cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup

cat <<EOT> /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

cat <<EOT> /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096


[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable sonarqube.service
systemctl start sonarqube.service

rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default

cat <<EOT> /etc/nginx/sites-available/sonarqube
server{
    listen      80;
    server_name sonarqube.groophy.in;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
              
        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOT

ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube

systemctl enable nginx.service
systemctl restart nginx.service