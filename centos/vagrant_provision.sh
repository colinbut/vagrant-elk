#!/usr/bin/env bash

# upating yum first
sudo yum update

# installing 'Extra Packages for Enterprise Linux'
# yum package manager does not have all latest software on its default repository
sudo yum install -y epel-release
sudo yum install -y wget
sudo yum install -y unzip

# Java (Runtime)
echo "Downloading & Installing latest Java runtime (jre)"
sudo su -
cd /opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jre-8u40-linux-x64.tar.gz"
tar xvf jre-8*.tar.gz
chown -R root: jre1.8*
rm jre-8*.tar.gz
alternatives --install /usr/bin/java java /opt/jre1.8*/bin/java 1

# ElasticSearch
echo "Downloading & Installing ElasticSearch"
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.noarch.rpm
rpm -Uvh elasticsearch-1.5.0.noarch.rpm

echo "Configuring ElasticSearch to start on startup"
systemctl daemon-reload
systemctl enable elasticsearch.service

echo "Starting ElasticSearch"
systemctl start elasticsearch.service

# LogStash
echo "Downloading & Installing LogStash"
cat >> /etc/yum.repos.d/logstash.repo << REPO
[logstash-1.5]
name=logstash repository for 1.5.x packages
baseurl=http://packages.elasticsearch.org/logstash/1.5/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
REPO
yum install -y logstash

# Kibana
echo "Downloading & Installing Kibana"
wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.2-linux-x64.tar.gz
tar -zxvf kibana-4.0.2-linux-x64.tar.gz
mv kibana-4.0.2-linux-x64 /opt/kibana4


echo "Configuring Kibana to start on startup"
sed -i 's/#pid_file/pid_file/g' /opt/kibana4/config/kibana.yml
cat >> /etc/systemd/system/kibana4.service << KIBANA
[Unit]
Description=Kibana 4 Web Interface
After=elasticsearch.service
After=logstash.service
[Service]
ExecStartPre=rm -rf /var/run/kibana.pid
ExecStart=/opt/kibana4/bin/kibana/
ExecReload=kill -9 $(cat /var/run/kibana.pid) && rm -rf /var/run/kibana.pid && /opt/kibana4/bin/kibana/
ExecStop=kill -9 $(cat /var/run/kibana.pid)
[Install]
WantedBy=multi-user.target
KIBANA

systemctl enable kibana4.service

echo "Starting Kibana..."
systemctl start kibana4.service





