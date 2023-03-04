#!/bin/bash

set -e

case $1 in
  7) V=7;;
  8) V=8;;
  *) echo "$0: <7|8>"; exit 1;;
esac

########################
# Install Elastic repo #
########################
ELASTICGPGKEY="/etc/apt/trusted.gpg.d/elasticsearch.gpg"
wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch -O- | gpg --dearmor -o ${ELASTICGPGKEY}
echo "deb [signed-by=${ELASTICGPGKEY}] https://artifacts.elastic.co/packages/${V}.x/apt stable main" | \
tee -a /etc/apt/sources.list.d/elastic.list

# ------------------------------------------------------------------------------
# Install elasticsearch and kibana from elastic repo
# Optional: install filebeat and logstash
apt-get update
apt-get install -y elasticsearch kibana
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Configure Elasticsearch
rm -fv /etc/elasticsearch/elasticsearch.yml
mkdir -p /usr/share/elasticsearch/config/
cp -fv /elasticsearch/elasticsearch.yml /usr/share/elasticsearch/config/
ln -sfv /usr/share/elasticsearch/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
mkdir -p /usr/share/elasticsearch/data
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

# ------------------------------------------------------------------------------
# Configure Kibana
rm -fv /etc/kibana/kibana.yml
mkdir -p /usr/share/kibana/config/
cp /kibana/kibana.yml /usr/share/kibana/config/
ln -sfv /usr/share/kibana/config/kibana.yml /etc/kibana/kibana.yml
