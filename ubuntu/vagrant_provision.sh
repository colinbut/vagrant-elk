#!/usr/bin/env bash

echo "Adding apt-key and repository for ElasticSearch"
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# not using add-apt-repository because it will add deb-src entry which elasticsearch doesn't provide
echo "deb http://packages.elastic.co/elasticsearch/1.4/debian stable main" | sudo tee -a /etc/apt/sources.list


sudo apt-get update

#Java
 
echo "Installing Java 7"
if [ ! -f /usr/lib/jvm/java-7-oracle/bin/java ];
then
	echo "Installing Java 7"
	sudo apt-get install -y software-properties-common python-software-properties
	echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt-get update
	sudo apt-get install oracle-java7-installer
	echo "Setting environment variables for Java 8"
	sudo apt-get install -y oracle-java7-set-default
else
	echo "Java 7 already installed - skipping"
fi

# ElasticSearch

echo "Installing ElasticSearch"
sudo apt-get install -y elasticsearch

sudo update-rc.d elasticsearch defaults 95 10

echo "Starting elasticsearch..."
sudo service elasticsearch start

# LogStash

echo "Downloading LogStash"
wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb

echo 'Installing LogStash'
dpkg -i logstash_1.4.2-1-2c0f5a1_all.deb

echo "Downloading community plugins for LogStash as well"
wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash-contrib_1.4.2-1-efd53ef_all.deb

echo "Installing community plugins for LogStash as well"
dpkg -i logstash-contrib_1.4.2-1-efd53ef_all.deb

sudo cp -v /home/vagrant/logstash.conf /opt/logstash/bin/

echo "Starting LogStash"
sudo /opt/logstash/bin/logstash -f logstash.conf &

# Kibana

echo "Downloading Kibana"
wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz

echo 'Extracting Kibana to /opt directory'
tar -xvf kibana-4.0.1-linux-x64.tar.gz -C /opt

echo "Starting Kibana"
sudo /opt/kibana-4.0.1-linux-x64/bin/kibana


