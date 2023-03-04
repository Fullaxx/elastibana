# ------------------------------------------------------------------------------
# Thanks to Jason Barnett - <xasmodeanx@gmail.com>
# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:jammy
MAINTAINER Brett Kuskie <fullaxx@gmail.com>

# ------------------------------------------------------------------------------
# Set environment variables
ENV LANG C
ENV TZ Etc/Zulu
ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------
# Install tools from ubuntu repo
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-transport-https bc curl file gnupg2 lsof nano net-tools \
      software-properties-common supervisor tree wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Copy our basic configuration
COPY overlay /

# ------------------------------------------------------------------------------
# Install Elasticsearch and Kibana
RUN /install/install_elastic_packages.sh 7

# ------------------------------------------------------------------------------
# Install docker healthcheck
HEALTHCHECK CMD /docker/healthcheck.sh

# ------------------------------------------------------------------------------
# Expose Ports
# 80(Kibana HTTP)
# 443(Kibana HTTPS)
# 5601(Kibana HTTP)
# 9200(Elastic API)
# 9300(Elastic comms) - DO NOT EXPOSE THIS PORT WITHOUT LICENSING AND SECURING
EXPOSE 80 443 5601 9200

# ------------------------------------------------------------------------------
# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
