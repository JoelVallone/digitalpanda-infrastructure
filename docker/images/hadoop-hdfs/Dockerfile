FROM ubuntu:16.04
MAINTAINER Joel Vallone <joel.vallone@gmail.com>

ENV JAVA_HEAP_SIZE 2048

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk wget && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME  /usr/lib/jvm/java-8-openjdk-amd64

RUN mkdir -p /opt/hadoop && \
    cd /opt/hadoop && \
    wget http://mirror.switch.ch/mirror/apache/dist/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz && \
    tar -zxf hadoop-2.9.0.tar.gz && \
    rm hadoop-2.9.0.tar.gz;

ENV HADOOP_BASE  /opt/hadoop
WORKDIR ${HADOOP_BASE}
ENV HADOOP_PREFIX ${HADOOP_BASE}/hadoop-2.9.0
RUN mkdir -p $HADOOP_BASE/hdfs/master/data && \
    mkdir -p $HADOOP_BASE/hdfs/slave/data && \
    mkdir -p $HADOOP_BASE/config && \
    mkdir -p $HADOOP_BASE/log
ENV HADOOP_CONF_DIR ${HADOOP_BASE}/config

COPY entrypoint.sh /opt/entrypoint.sh

COPY default-config ${HADOOP_BASE}/config

EXPOSE 8080

ENTRYPOINT /opt/entrypoint.sh