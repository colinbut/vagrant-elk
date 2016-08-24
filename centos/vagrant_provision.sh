#!/usr/bin/env bash

# upating yum first
sudo yum update

# installing 'Extra Packages for Enterprise Linux'
# yum package manager does not have all latest software on its default repository
sudo yum install -y epel-release
sudo yum install -y wget
sudo yum install -y unzip

echo "Downloading & Installing latest Java runtime (jre)"
sudo su -
cd /opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jre-8u40-linux-x64.tar.gz"
tar xvf jre-8*.tar.gz
chown -R root: jre1.8*
rm jre-8*.tar.gz
alternatives --install /usr/bin/java java /opt/jre1.8*/bin/java 1

echo "Downloading & Installing ElasticSearch"
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.noarch.rpm
rpm -Uvh elasticsearch-1.5.0.noarch.rpm

