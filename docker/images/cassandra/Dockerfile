FROM ubuntu:16.04
MAINTAINER Joel Vallone <joel.vallone@gmail.com>

ENV JAVA_HOME  /usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_HEAP_SIZE 2048
ENV CASSANDRA_BASE /opt/cassandra
ENV CASSANDRA_BIN ${CASSANDRA_BASE}/apache-cassandra-3.11.3
ENV CASSANDRA_CONF_DIR ${CASSANDRA_BASE}/ext/conf
ENV CASSANDRA_AUTO_START false
ENV CASSANDRA_LOG_DIR ${CASSANDRA_BASE}/ext/logs

# Install java 8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk wget && \
    rm -rf /var/lib/apt/lists/*

# Install cassandra 3.11.3
RUN mkdir -p ${CASSANDRA_BASE} && \
    cd ${CASSANDRA_BASE} && \
    wget http://mirror.switch.ch/mirror/apache/dist/cassandra/3.11.3/apache-cassandra-3.11.3-bin.tar.gz && \
    tar -zxf apache-cassandra-3.11.3-bin.tar.gz && \
    rm apache-cassandra-3.11.3-bin.tar.gz;

# Setup cassandra directories
WORKDIR ${CASSANDRA_BASE}
RUN mkdir -p $CASSANDRA_BASE/ext/data/datafile && \
    mkdir -p $CASSANDRA_BASE/ext/data/cdc && \
    mkdir -p $CASSANDRA_BASE/ext/data/commitlog && \
    mkdir -p $CASSANDRA_BASE/ext/logs/

# Load default settings
COPY entrypoint.sh /opt/entrypoint.sh
COPY default-config ${CASSANDRA_CONF_DIR}

ENTRYPOINT /opt/entrypoint.sh