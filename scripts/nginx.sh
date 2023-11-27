apt update && apt install -y nginx
cat <<EOT > jenkins
upstream jenkins {
    server jenkins:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://jenkins;
    }
}
EOT

mv jenkins /etc/nginx/sites-available/jenkins
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/jenkins

systemctl start nginx
systemctl enable nginx
systemctl restart nginx